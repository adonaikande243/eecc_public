-- ============================================================================
-- ÉCOSYSTÈME EECC (Église Évangélique du Congo Centre)
-- Schéma de Base de Données Supabase (PostgreSQL)
-- Version : 1.0.0
-- ============================================================================

-- Activer les extensions utiles
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- 1. TABLE : eecc_lives (Diffusion en direct des cultes)
-- Utilisée par la Régie Studio (publication) et les Apps Mobile (réception temps réel)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.eecc_lives (
    id TEXT PRIMARY KEY,
    titre TEXT NOT NULL DEFAULT 'Culte en Direct',
    predicateur TEXT NOT NULL DEFAULT 'Pasteur',
    is_live BOOLEAN NOT NULL DEFAULT false,
    sur_app_mobile BOOLEAN NOT NULL DEFAULT true,
    sur_youtube BOOLEAN NOT NULL DEFAULT false,
    sur_facebook BOOLEAN NOT NULL DEFAULT false,
    youtube_url TEXT,
    facebook_url TEXT,
    stream_url_app TEXT,
    started_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    ended_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- Index pour accélérer la détection du culte en cours
CREATE INDEX IF NOT EXISTS idx_eecc_lives_is_live ON public.eecc_lives (is_live, started_at DESC);

-- ============================================================================
-- 2. TABLE : eecc_archives (Cultes enregistrés et archivés sur Google Drive)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.eecc_archives (
    id TEXT PRIMARY KEY,
    titre TEXT NOT NULL,
    predicateur TEXT NOT NULL,
    date_culte TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    video_drive_id TEXT,
    video_drive_url TEXT,
    audio_drive_id TEXT,
    audio_drive_url TEXT,
    resume_drive_url TEXT,
    resume_texte TEXT,
    duree_secondes INTEGER,
    taille_octets BIGINT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE INDEX IF NOT EXISTS idx_eecc_archives_date ON public.eecc_archives (date_culte DESC);

-- ============================================================================
-- 3. TABLE : eecc_offrandes (Dîmes, dons et offrandes traités via Maishapay)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.eecc_offrandes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reference TEXT NOT NULL UNIQUE,
    montant NUMERIC(12, 2) NOT NULL,
    devise VARCHAR(5) NOT NULL DEFAULT 'USD',
    type_offrande TEXT NOT NULL DEFAULT 'Offrande ordinaire',
    nom_fidele TEXT NOT NULL DEFAULT 'Fidèle EECC',
    telephone VARCHAR(30),
    email VARCHAR(150),
    canal VARCHAR(30) NOT NULL DEFAULT 'MPESA', -- MPESA, AIRTEL_MONEY, ORANGE_MONEY, VISA, MASTERCARD
    statut VARCHAR(30) NOT NULL DEFAULT 'VALIDE', -- VALIDE, EN_ATTENTE, ECHEC
    details_transaction JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE INDEX IF NOT EXISTS idx_eecc_offrandes_created ON public.eecc_offrandes (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_eecc_offrandes_canal ON public.eecc_offrandes (canal);
CREATE INDEX IF NOT EXISTS idx_eecc_offrandes_type ON public.eecc_offrandes (type_offrande);

-- ============================================================================
-- 4. TABLE : eecc_prieres (Requêtes de prière soumises en direct par les fidèles)
-- Reçues en temps réel par les pasteurs pendant le direct
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.eecc_prieres (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nom_fidele TEXT NOT NULL,
    telephone VARCHAR(30),
    sujet TEXT NOT NULL,
    culte_id TEXT REFERENCES public.eecc_lives(id) ON DELETE SET NULL,
    statut VARCHAR(30) NOT NULL DEFAULT 'En attente', -- 'En attente', 'Prié & Béni'
    reponse_pastorale TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE INDEX IF NOT EXISTS idx_eecc_prieres_statut ON public.eecc_prieres (statut, created_at ASC);

-- ============================================================================
-- 5. TABLE : eecc_auth_otp (Codes OTP pour connexion sécurisée par e-mail / SMS)
-- Gérée avec le service Brevo
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.eecc_auth_otp (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    identifiant VARCHAR(150) NOT NULL, -- email ou numéro de téléphone
    code_otp VARCHAR(10) NOT NULL,
    expire_at TIMESTAMPTZ NOT NULL,
    utilise BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE INDEX IF NOT EXISTS idx_eecc_auth_otp ON public.eecc_auth_otp (identifiant, code_otp, utilise);

-- ============================================================================
-- 6. POLITIQUES DE SÉCURITÉ ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Activer RLS sur toutes les tables
ALTER TABLE public.eecc_lives ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.eecc_archives ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.eecc_offrandes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.eecc_prieres ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.eecc_auth_otp ENABLE ROW LEVEL SECURITY;

-- 6.1 Politiques pour eecc_lives :
-- Tout le monde (fidèles, public) peut lire le statut du live
CREATE POLICY "Lecture publique du live" ON public.eecc_lives
    FOR SELECT USING (true);

-- Seul le service_role (Régie Studio) peut insérer/modifier le live
CREATE POLICY "Gestion live réservée à la régie" ON public.eecc_lives
    FOR ALL USING (auth.role() = 'service_role' OR auth.role() = 'authenticated');

-- 6.2 Politiques pour eecc_archives :
-- Tout le monde peut consulter les archives de culte
CREATE POLICY "Lecture publique des archives" ON public.eecc_archives
    FOR SELECT USING (true);

CREATE POLICY "Création archives régie" ON public.eecc_archives
    FOR ALL USING (auth.role() = 'service_role' OR auth.role() = 'authenticated');

-- 6.3 Politiques pour eecc_offrandes :
-- Insertion autorisée pour tout utilisateur (avec clé anon ou authenticated)
CREATE POLICY "Enregistrement offrande publique" ON public.eecc_offrandes
    FOR INSERT WITH CHECK (true);

-- Consultation réservée aux pasteurs et administrateurs (service_role)
CREATE POLICY "Lecture offrandes pastorale" ON public.eecc_offrandes
    FOR SELECT USING (auth.role() = 'service_role' OR auth.role() = 'authenticated');

-- 6.4 Politiques pour eecc_prieres :
-- Tout fidèle peut soumettre une prière
CREATE POLICY "Soumission requête de prière" ON public.eecc_prieres
    FOR INSERT WITH CHECK (true);

-- Les pasteurs peuvent lire et modifier (marquer 'Prié')
CREATE POLICY "Lecture et gestion prières pasteurs" ON public.eecc_prieres
    FOR ALL USING (true);

-- 6.5 Politiques pour eecc_auth_otp :
CREATE POLICY "Gestion OTP service_role" ON public.eecc_auth_otp
    FOR ALL USING (auth.role() = 'service_role' OR auth.role() = 'anon');

-- ============================================================================
-- 7. ACTIVATION DE SUPABASE REALTIME (WebSockets)
-- Permet aux applications mobiles de recevoir le direct et les prières instantanément
-- ============================================================================
ALTER PUBLICATION supabase_realtime ADD TABLE public.eecc_lives;
ALTER PUBLICATION supabase_realtime ADD TABLE public.eecc_prieres;
ALTER PUBLICATION supabase_realtime ADD TABLE public.eecc_archives;
