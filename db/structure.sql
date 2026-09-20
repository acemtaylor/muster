SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: ltree; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;


--
-- Name: EXTENSION ltree; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION ltree IS 'data type for hierarchical tree-like structures';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: assessment_status_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_status_changes (
    id bigint NOT NULL,
    person_id bigint NOT NULL,
    changed_by_id bigint,
    old_status text,
    new_status text,
    changed_at timestamp(6) without time zone DEFAULT now() NOT NULL
);


--
-- Name: assessment_status_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assessment_status_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessment_status_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assessment_status_changes_id_seq OWNED BY public.assessment_status_changes.id;


--
-- Name: assessment_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_statuses (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    key text NOT NULL,
    label text NOT NULL,
    color text,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: assessment_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assessment_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessment_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assessment_statuses_id_seq OWNED BY public.assessment_statuses.id;


--
-- Name: custom_property_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_property_definitions (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    key text NOT NULL,
    label text NOT NULL,
    data_type text NOT NULL,
    options jsonb DEFAULT '[]'::jsonb,
    group_name text,
    "position" integer DEFAULT 0,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: custom_property_definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_property_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_property_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_property_definitions_id_seq OWNED BY public.custom_property_definitions.id;


--
-- Name: custom_property_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_property_values (
    id bigint NOT NULL,
    person_id bigint NOT NULL,
    definition_id bigint NOT NULL,
    value jsonb
);


--
-- Name: custom_property_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_property_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_property_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_property_values_id_seq OWNED BY public.custom_property_values.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id bigint NOT NULL,
    parent_id bigint,
    name text NOT NULL,
    slug text NOT NULL,
    kind text DEFAULT 'organization'::text NOT NULL,
    path public.ltree,
    depth integer DEFAULT 0 NOT NULL,
    country text,
    timezone text DEFAULT 'UTC'::text,
    settings jsonb DEFAULT '{}'::jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    first_name text,
    last_name text,
    alternate_name text,
    email public.citext,
    phone_number text,
    secondary_phone text,
    date_of_birth date,
    address_1 text,
    address_2 text,
    city text,
    state text,
    postal_code text,
    country text,
    geom public.geography(Point,4326),
    preferred_language text DEFAULT 'en'::text,
    assessment text,
    created_by_method text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.people_id_seq OWNED BY public.people.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: team_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_members (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp(6) without time zone,
    last_sign_in_at timestamp(6) without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    organization_id bigint NOT NULL,
    role text DEFAULT 'volunteer'::text NOT NULL,
    scope_org_ids bigint[] DEFAULT '{}'::bigint[] NOT NULL,
    mfa_secret text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: team_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_members_id_seq OWNED BY public.team_members.id;


--
-- Name: assessment_status_changes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_status_changes ALTER COLUMN id SET DEFAULT nextval('public.assessment_status_changes_id_seq'::regclass);


--
-- Name: assessment_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_statuses ALTER COLUMN id SET DEFAULT nextval('public.assessment_statuses_id_seq'::regclass);


--
-- Name: custom_property_definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_property_definitions ALTER COLUMN id SET DEFAULT nextval('public.custom_property_definitions_id_seq'::regclass);


--
-- Name: custom_property_values id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_property_values ALTER COLUMN id SET DEFAULT nextval('public.custom_property_values_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- Name: team_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members ALTER COLUMN id SET DEFAULT nextval('public.team_members_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: assessment_status_changes assessment_status_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_status_changes
    ADD CONSTRAINT assessment_status_changes_pkey PRIMARY KEY (id);


--
-- Name: assessment_statuses assessment_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_statuses
    ADD CONSTRAINT assessment_statuses_pkey PRIMARY KEY (id);


--
-- Name: custom_property_definitions custom_property_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_property_definitions
    ADD CONSTRAINT custom_property_definitions_pkey PRIMARY KEY (id);


--
-- Name: custom_property_values custom_property_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_property_values
    ADD CONSTRAINT custom_property_values_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: team_members team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (id);


--
-- Name: idx_cpv_person_definition; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_cpv_person_definition ON public.custom_property_values USING btree (person_id, definition_id);


--
-- Name: idx_people_org_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_people_org_email ON public.people USING btree (organization_id, email);


--
-- Name: idx_people_org_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_people_org_phone ON public.people USING btree (organization_id, phone_number);


--
-- Name: idx_people_search; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_people_search ON public.people USING gin (to_tsvector('english'::regconfig, ((((COALESCE(first_name, ''::text) || ' '::text) || COALESCE(last_name, ''::text)) || ' '::text) || (COALESCE(email, ''::public.citext))::text)));


--
-- Name: index_assessment_status_changes_on_changed_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assessment_status_changes_on_changed_by_id ON public.assessment_status_changes USING btree (changed_by_id);


--
-- Name: index_assessment_status_changes_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assessment_status_changes_on_person_id ON public.assessment_status_changes USING btree (person_id);


--
-- Name: index_assessment_statuses_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assessment_statuses_on_organization_id ON public.assessment_statuses USING btree (organization_id);


--
-- Name: index_assessment_statuses_on_organization_id_and_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_assessment_statuses_on_organization_id_and_key ON public.assessment_statuses USING btree (organization_id, key);


--
-- Name: index_custom_property_definitions_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_property_definitions_on_organization_id ON public.custom_property_definitions USING btree (organization_id);


--
-- Name: index_custom_property_definitions_on_organization_id_and_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_custom_property_definitions_on_organization_id_and_key ON public.custom_property_definitions USING btree (organization_id, key);


--
-- Name: index_custom_property_values_on_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_property_values_on_definition_id ON public.custom_property_values USING btree (definition_id);


--
-- Name: index_custom_property_values_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_property_values_on_person_id ON public.custom_property_values USING btree (person_id);


--
-- Name: index_custom_property_values_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_property_values_on_value ON public.custom_property_values USING gin (value);


--
-- Name: index_organizations_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_parent_id ON public.organizations USING btree (parent_id);


--
-- Name: index_organizations_on_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_path ON public.organizations USING gist (path);


--
-- Name: index_organizations_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organizations_on_slug ON public.organizations USING btree (slug);


--
-- Name: index_people_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_email ON public.people USING btree (email);


--
-- Name: index_people_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_organization_id ON public.people USING btree (organization_id);


--
-- Name: index_people_on_phone_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_phone_number ON public.people USING btree (phone_number);


--
-- Name: index_team_members_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_team_members_on_email ON public.team_members USING btree (email);


--
-- Name: index_team_members_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_team_members_on_organization_id ON public.team_members USING btree (organization_id);


--
-- Name: index_team_members_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_team_members_on_reset_password_token ON public.team_members USING btree (reset_password_token);


--
-- Name: custom_property_definitions fk_rails_0cecd45e5a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_property_definitions
    ADD CONSTRAINT fk_rails_0cecd45e5a FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: assessment_status_changes fk_rails_3b76d3820f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_status_changes
    ADD CONSTRAINT fk_rails_3b76d3820f FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: custom_property_values fk_rails_40cc5f1345; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_property_values
    ADD CONSTRAINT fk_rails_40cc5f1345 FOREIGN KEY (definition_id) REFERENCES public.custom_property_definitions(id);


--
-- Name: organizations fk_rails_6551137b98; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT fk_rails_6551137b98 FOREIGN KEY (parent_id) REFERENCES public.organizations(id);


--
-- Name: team_members fk_rails_99fbd57ee0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT fk_rails_99fbd57ee0 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: people fk_rails_cc3c1c1fca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT fk_rails_cc3c1c1fca FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: custom_property_values fk_rails_d0ff2356c6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_property_values
    ADD CONSTRAINT fk_rails_d0ff2356c6 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: assessment_statuses fk_rails_e7972097ee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_statuses
    ADD CONSTRAINT fk_rails_e7972097ee FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: assessment_status_changes fk_rails_fb55a185a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_status_changes
    ADD CONSTRAINT fk_rails_fb55a185a3 FOREIGN KEY (changed_by_id) REFERENCES public.team_members(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20260919070651'),
('20260919070445'),
('20260919070044'),
('20260919065361'),
('20260919065360'),
('20260919065359'),
('20260918105446'),
('20260918103422'),
('20260918101609');

