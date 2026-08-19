-- ========================================================================
-- IGI Core Specification: Database Registry Schema & Inbound Sync Triggers
-- Reference: Inbound Processing Triggers [1.1] / target: quorum-master
-- ========================================================================

-- 1. Certified Entities Tracker (Enterprise Client Node States)
CREATE TABLE IF NOT EXISTS icit_certified_entities (
    entity_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_name VARCHAR(255) NOT NULL,
    global_compliance_variable NUMERIC(5,2) NOT NULL DEFAULT 0.00,
    node_server_count INT NOT NULL DEFAULT 1,
    corporate_subscription_status VARCHAR(50) NOT NULL DEFAULT 'PENDING_AUDIT',
    last_sync_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Licenses Registry (Individual & Developer Validation Keys)
CREATE TABLE IF NOT EXISTS icit_licenses_registered (
    license_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    license_key VARCHAR(100) UNIQUE NOT NULL,
    cryptographic_signature_hash VARCHAR(256) NOT NULL,
    applicant_target_basin VARCHAR(100) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Allocated Engineer Render (Active Commercial Deployment Mappings)
CREATE TABLE IF NOT EXISTS allocated_engineer_render (
    allocation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    license_key VARCHAR(100) REFERENCES icit_licenses_registered(license_key),
    assigned_entity_id UUID REFERENCES icit_certified_entities(entity_id),
    deployment_status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE_REMEDIATION',
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Quorum-Master Inbound Sync Protection Trigger
CREATE OR REPLACE FUNCTION verify_quorum_sync_mechanics()
RETURNS TRIGGER AS $$
BEGIN
    -- Enforce absolute base-10 equilibrium boundaries on state changes
    IF NEW.global_compliance_variable > 10.00 THEN
        RAISE EXCEPTION 'Systemic parameter drift detected: Out of baseline bounds.';
    END IF;
    
    NEW.last_sync_timestamp := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_quorum_master_sync
    BEFORE UPDATE ON icit_certified_entities
    FOR EACH ROW
    EXECUTE FUNCTION verify_quorum_sync_mechanics();

-- ========================================================================
-- SYSTEM REGISTRY INITIALIZED // PROTECTED INBOUND AGGREGATION CORE ACTIVE
-- ========================================================================
