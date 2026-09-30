-- ============================================================================
-- ÉCOSYSTÈME EECC : Données Initiales / Démonstration (Seed Data)
-- À exécuter optionnellement dans Supabase SQL Editor
-- ============================================================================

-- 1. Un culte archivé d'exemple (pour tester la liste des archives sur mobile)
INSERT INTO public.eecc_archives (
    id,
    titre,
    predicateur,
    date_culte,
    video_drive_id,
    video_drive_url,
    resume_texte
) VALUES (
    'culte-inaugural-2026',
    'La Foi Triomphante dans les Épreuves',
    'Pasteur Principal EECC',
    NOW() - INTERVAL '7 days',
    '1A2B3C4D5E6F7G8H9',
    'https://drive.google.com/file/d/1A2B3C4D5E6F7G8H9/view',
    'Message puissant basé sur Hébreux 11:1-6. Dieu nous appelle à persévérer dans la prière et l''obéissance.'
) ON CONFLICT (id) DO NOTHING;

-- 2. Quelques offrandes de test pour valider les graphiques et totaux pastoraux
INSERT INTO public.eecc_offrandes (
    reference,
    montant,
    devise,
    type_offrande,
    nom_fidele,
    telephone,
    email,
    canal,
    statut
) VALUES
    ('OFF-DEMO-001', 50.00, 'USD', 'Dîme', 'Frère Jean Bosco', '+243812345678', 'jean.bosco@eecc.org', 'MPESA', 'VALIDE'),
    ('OFF-DEMO-002', 20.00, 'USD', 'Offrande ordinaire', 'Sœur Mireille K.', '+243971234567', 'mireille.k@gmail.com', 'AIRTEL_MONEY', 'VALIDE'),
    ('OFF-DEMO-003', 100.00, 'USD', 'Don de construction', 'Famille Mukendi', '+243841234567', 'mukendi@yahoo.fr', 'ORANGE_MONEY', 'VALIDE'),
    ('OFF-DEMO-004', 150.00, 'USD', 'Dîme pastorale', 'Pasteur Associé', '+243819876543', 'pasteur.associe@eecc.org', 'VISA', 'VALIDE'),
    ('OFF-DEMO-005', 75.00, 'USD', 'Action de grâce', 'Frère Patrick M.', '+243825556677', 'patrick.m@hotmail.com', 'MASTERCARD', 'VALIDE')
ON CONFLICT (reference) DO NOTHING;

-- 3. Requêtes de prière de test
INSERT INTO public.eecc_prieres (
    nom_fidele,
    telephone,
    sujet,
    statut
) VALUES
    ('Sœur Marie Claire', '+243812345678', 'Prière d''intercession pour la guérison de mon fils hospitalisé.', 'En attente'),
    ('Frère David Mukendi', '+243899876543', 'Action de grâce pour la naissance de notre premier enfant.', 'En attente')
;
