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
-- Name: canvass_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.canvass_attempts (
    id bigint NOT NULL,
    canvass_id bigint NOT NULL,
    turf_id bigint,
    person_id bigint,
    canvasser_id bigint,
    knock_result text,
    occurred_at timestamp(6) without time zone DEFAULT now() NOT NULL
);


--
-- Name: canvass_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.canvass_attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: canvass_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.canvass_attempts_id_seq OWNED BY public.canvass_attempts.id;


--
-- Name: canvasses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.canvasses (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    name text NOT NULL,
    script text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: canvasses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.canvasses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: canvasses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.canvasses_id_seq OWNED BY public.canvasses.id;


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
-- Name: donations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.donations (
    id bigint NOT NULL,
    person_id bigint,
    amount_cents integer NOT NULL,
    currency text DEFAULT 'USD'::text NOT NULL,
    is_recurring boolean DEFAULT false NOT NULL,
    processor text,
    processor_ref text,
    occurred_at timestamp(6) without time zone DEFAULT now() NOT NULL
);


--
-- Name: donations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.donations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: donations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.donations_id_seq OWNED BY public.donations.id;


--
-- Name: event_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_locations (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    name text NOT NULL,
    address text,
    geom public.geography(Point,4326),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: event_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_locations_id_seq OWNED BY public.event_locations.id;


--
-- Name: event_rsvps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_rsvps (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    person_id bigint NOT NULL,
    status text NOT NULL,
    attended boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: event_rsvps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_rsvps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_rsvps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_rsvps_id_seq OWNED BY public.event_rsvps.id;


--
-- Name: event_shifts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_shifts (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    event_location_id bigint,
    title text,
    starts_at timestamp(6) without time zone NOT NULL,
    ends_at timestamp(6) without time zone NOT NULL,
    role text,
    capacity integer,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: event_shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_shifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_shifts_id_seq OWNED BY public.event_shifts.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    title text NOT NULL,
    description text,
    starts_at timestamp(6) without time zone NOT NULL,
    ends_at timestamp(6) without time zone,
    is_multi_day boolean DEFAULT false NOT NULL,
    virtual_url text,
    recurrence_rule text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: list_folders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.list_folders (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: list_folders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.list_folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: list_folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.list_folders_id_seq OWNED BY public.list_folders.id;


--
-- Name: membership_payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.membership_payments (
    id bigint NOT NULL,
    membership_id bigint NOT NULL,
    amount_cents integer NOT NULL,
    processor text,
    processor_ref text,
    paid_at timestamp(6) without time zone DEFAULT now() NOT NULL
);


--
-- Name: membership_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.membership_payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: membership_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.membership_payments_id_seq OWNED BY public.membership_payments.id;


--
-- Name: membership_tiers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.membership_tiers (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    name text NOT NULL,
    billing_period text NOT NULL,
    price_cents integer,
    income_based boolean DEFAULT false NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: membership_tiers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.membership_tiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: membership_tiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.membership_tiers_id_seq OWNED BY public.membership_tiers.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.memberships (
    id bigint NOT NULL,
    person_id bigint NOT NULL,
    membership_tier_id bigint NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    started_at timestamp(6) without time zone DEFAULT now() NOT NULL,
    expires_at timestamp(6) without time zone,
    auto_renew boolean DEFAULT true NOT NULL,
    cancelled_at timestamp(6) without time zone,
    stripe_subscription_id text,
    amount_cents integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.memberships_id_seq OWNED BY public.memberships.id;


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
-- Name: saved_list_memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.saved_list_memberships (
    saved_list_id bigint NOT NULL,
    subject_type text NOT NULL,
    subject_id bigint NOT NULL
);


--
-- Name: saved_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.saved_lists (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    folder_id bigint,
    name text NOT NULL,
    subject_type text DEFAULT 'person'::text NOT NULL,
    filter_json jsonb NOT NULL,
    is_dynamic boolean DEFAULT true NOT NULL,
    created_by_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: saved_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.saved_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: saved_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.saved_lists_id_seq OWNED BY public.saved_lists.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: shift_signups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shift_signups (
    id bigint NOT NULL,
    event_shift_id bigint NOT NULL,
    person_id bigint NOT NULL,
    role text,
    status text DEFAULT 'confirmed'::text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: shift_signups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shift_signups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shift_signups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shift_signups_id_seq OWNED BY public.shift_signups.id;


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
-- Name: turfs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.turfs (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    name text NOT NULL,
    boundary public.geography(Polygon,4326) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: turfs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.turfs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: turfs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.turfs_id_seq OWNED BY public.turfs.id;


--
-- Name: assessment_status_changes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_status_changes ALTER COLUMN id SET DEFAULT nextval('public.assessment_status_changes_id_seq'::regclass);


--
-- Name: assessment_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_statuses ALTER COLUMN id SET DEFAULT nextval('public.assessment_statuses_id_seq'::regclass);


--
-- Name: canvass_attempts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.canvass_attempts ALTER COLUMN id SET DEFAULT nextval('public.canvass_attempts_id_seq'::regclass);


--
-- Name: canvasses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.canvasses ALTER COLUMN id SET DEFAULT nextval('public.canvasses_id_seq'::regclass);


--
-- Name: custom_property_definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_property_definitions ALTER COLUMN id SET DEFAULT nextval('public.custom_property_definitions_id_seq'::regclass);


--
-- Name: custom_property_values id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_property_values ALTER COLUMN id SET DEFAULT nextval('public.custom_property_values_id_seq'::regclass);


--
-- Name: donations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donations ALTER COLUMN id SET DEFAULT nextval('public.donations_id_seq'::regclass);


--
-- Name: event_locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_locations ALTER COLUMN id SET DEFAULT nextval('public.event_locations_id_seq'::regclass);


--
-- Name: event_rsvps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_rsvps ALTER COLUMN id SET DEFAULT nextval('public.event_rsvps_id_seq'::regclass);


--
-- Name: event_shifts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_shifts ALTER COLUMN id SET DEFAULT nextval('public.event_shifts_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: list_folders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.list_folders ALTER COLUMN id SET DEFAULT nextval('public.list_folders_id_seq'::regclass);


--
-- Name: membership_payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.membership_payments ALTER COLUMN id SET DEFAULT nextval('public.membership_payments_id_seq'::regclass);


--
-- Name: membership_tiers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.membership_tiers ALTER COLUMN id SET DEFAULT nextval('public.membership_tiers_id_seq'::regclass);


--
-- Name: memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships ALTER COLUMN id SET DEFAULT nextval('public.memberships_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- Name: saved_lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_lists ALTER COLUMN id SET DEFAULT nextval('public.saved_lists_id_seq'::regclass);


--
-- Name: shift_signups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_signups ALTER COLUMN id SET DEFAULT nextval('public.shift_signups_id_seq'::regclass);


--
-- Name: team_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members ALTER COLUMN id SET DEFAULT nextval('public.team_members_id_seq'::regclass);


--
-- Name: turfs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.turfs ALTER COLUMN id SET DEFAULT nextval('public.turfs_id_seq'::regclass);


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
-- Name: canvass_attempts canvass_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.canvass_attempts
    ADD CONSTRAINT canvass_attempts_pkey PRIMARY KEY (id);


--
-- Name: canvasses canvasses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.canvasses
    ADD CONSTRAINT canvasses_pkey PRIMARY KEY (id);


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
-- Name: donations donations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT donations_pkey PRIMARY KEY (id);


--
-- Name: event_locations event_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_locations
    ADD CONSTRAINT event_locations_pkey PRIMARY KEY (id);


--
-- Name: event_rsvps event_rsvps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_rsvps
    ADD CONSTRAINT event_rsvps_pkey PRIMARY KEY (id);


--
-- Name: event_shifts event_shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_shifts
    ADD CONSTRAINT event_shifts_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: list_folders list_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.list_folders
    ADD CONSTRAINT list_folders_pkey PRIMARY KEY (id);


--
-- Name: membership_payments membership_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.membership_payments
    ADD CONSTRAINT membership_payments_pkey PRIMARY KEY (id);


--
-- Name: membership_tiers membership_tiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.membership_tiers
    ADD CONSTRAINT membership_tiers_pkey PRIMARY KEY (id);


--
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


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
-- Name: saved_lists saved_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_lists
    ADD CONSTRAINT saved_lists_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: shift_signups shift_signups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_signups
    ADD CONSTRAINT shift_signups_pkey PRIMARY KEY (id);


--
-- Name: team_members team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (id);


--
-- Name: turfs turfs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.turfs
    ADD CONSTRAINT turfs_pkey PRIMARY KEY (id);


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
-- Name: idx_rsvps_event_person; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_rsvps_event_person ON public.event_rsvps USING btree (event_id, person_id);


--
-- Name: idx_signups_shift_person; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_signups_shift_person ON public.shift_signups USING btree (event_shift_id, person_id);


--
-- Name: idx_slm_primary; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_slm_primary ON public.saved_list_memberships USING btree (saved_list_id, subject_type, subject_id);


--
-- Name: idx_slm_subject; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_slm_subject ON public.saved_list_memberships USING btree (subject_type, subject_id);


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
-- Name: index_canvass_attempts_on_canvass_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_canvass_attempts_on_canvass_id ON public.canvass_attempts USING btree (canvass_id);


--
-- Name: index_canvass_attempts_on_canvasser_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_canvass_attempts_on_canvasser_id ON public.canvass_attempts USING btree (canvasser_id);


--
-- Name: index_canvass_attempts_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_canvass_attempts_on_person_id ON public.canvass_attempts USING btree (person_id);


--
-- Name: index_canvass_attempts_on_turf_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_canvass_attempts_on_turf_id ON public.canvass_attempts USING btree (turf_id);


--
-- Name: index_canvasses_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_canvasses_on_organization_id ON public.canvasses USING btree (organization_id);


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
-- Name: index_donations_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_donations_on_person_id ON public.donations USING btree (person_id);


--
-- Name: index_event_locations_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_locations_on_event_id ON public.event_locations USING btree (event_id);


--
-- Name: index_event_rsvps_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_rsvps_on_event_id ON public.event_rsvps USING btree (event_id);


--
-- Name: index_event_rsvps_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_rsvps_on_person_id ON public.event_rsvps USING btree (person_id);


--
-- Name: index_event_shifts_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_shifts_on_event_id ON public.event_shifts USING btree (event_id);


--
-- Name: index_event_shifts_on_event_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_shifts_on_event_location_id ON public.event_shifts USING btree (event_location_id);


--
-- Name: index_event_shifts_on_starts_at_and_ends_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_shifts_on_starts_at_and_ends_at ON public.event_shifts USING btree (starts_at, ends_at);


--
-- Name: index_events_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_organization_id ON public.events USING btree (organization_id);


--
-- Name: index_list_folders_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_list_folders_on_organization_id ON public.list_folders USING btree (organization_id);


--
-- Name: index_membership_payments_on_membership_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_membership_payments_on_membership_id ON public.membership_payments USING btree (membership_id);


--
-- Name: index_membership_tiers_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_membership_tiers_on_organization_id ON public.membership_tiers USING btree (organization_id);


--
-- Name: index_memberships_on_expires_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_expires_at ON public.memberships USING btree (expires_at);


--
-- Name: index_memberships_on_membership_tier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_membership_tier_id ON public.memberships USING btree (membership_tier_id);


--
-- Name: index_memberships_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_person_id ON public.memberships USING btree (person_id);


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
-- Name: index_saved_list_memberships_on_saved_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_saved_list_memberships_on_saved_list_id ON public.saved_list_memberships USING btree (saved_list_id);


--
-- Name: index_saved_lists_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_saved_lists_on_created_by_id ON public.saved_lists USING btree (created_by_id);


--
-- Name: index_saved_lists_on_folder_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_saved_lists_on_folder_id ON public.saved_lists USING btree (folder_id);


--
-- Name: index_saved_lists_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_saved_lists_on_organization_id ON public.saved_lists USING btree (organization_id);


--
-- Name: index_shift_signups_on_event_shift_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shift_signups_on_event_shift_id ON public.shift_signups USING btree (event_shift_id);


--
-- Name: index_shift_signups_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shift_signups_on_person_id ON public.shift_signups USING btree (person_id);


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
-- Name: index_turfs_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_turfs_on_organization_id ON public.turfs USING btree (organization_id);


--
-- Name: canvass_attempts fk_rails_0297923aa6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.canvass_attempts
    ADD CONSTRAINT fk_rails_0297923aa6 FOREIGN KEY (turf_id) REFERENCES public.turfs(id);


--
-- Name: shift_signups fk_rails_07b7adb7d1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_signups
    ADD CONSTRAINT fk_rails_07b7adb7d1 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: memberships fk_rails_092b9b8356; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT fk_rails_092b9b8356 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: custom_property_definitions fk_rails_0cecd45e5a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_property_definitions
    ADD CONSTRAINT fk_rails_0cecd45e5a FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: events fk_rails_163b5130b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_163b5130b5 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: membership_tiers fk_rails_17a848ed7a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.membership_tiers
    ADD CONSTRAINT fk_rails_17a848ed7a FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: shift_signups fk_rails_2987619d5a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_signups
    ADD CONSTRAINT fk_rails_2987619d5a FOREIGN KEY (event_shift_id) REFERENCES public.event_shifts(id);


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
-- Name: event_shifts fk_rails_44ce26eba2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_shifts
    ADD CONSTRAINT fk_rails_44ce26eba2 FOREIGN KEY (event_location_id) REFERENCES public.event_locations(id);


--
-- Name: canvass_attempts fk_rails_52726022e3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.canvass_attempts
    ADD CONSTRAINT fk_rails_52726022e3 FOREIGN KEY (canvasser_id) REFERENCES public.team_members(id);


--
-- Name: organizations fk_rails_6551137b98; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT fk_rails_6551137b98 FOREIGN KEY (parent_id) REFERENCES public.organizations(id);


--
-- Name: event_rsvps fk_rails_6bdac917c9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_rsvps
    ADD CONSTRAINT fk_rails_6bdac917c9 FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: canvass_attempts fk_rails_6d5a18ddbc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.canvass_attempts
    ADD CONSTRAINT fk_rails_6d5a18ddbc FOREIGN KEY (canvass_id) REFERENCES public.canvasses(id);


--
-- Name: donations fk_rails_776e99a61e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_776e99a61e FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: event_locations fk_rails_7c5d68f3b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_locations
    ADD CONSTRAINT fk_rails_7c5d68f3b5 FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: saved_list_memberships fk_rails_7d016c6a8e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_list_memberships
    ADD CONSTRAINT fk_rails_7d016c6a8e FOREIGN KEY (saved_list_id) REFERENCES public.saved_lists(id);


--
-- Name: turfs fk_rails_7f9cf3acc0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.turfs
    ADD CONSTRAINT fk_rails_7f9cf3acc0 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: memberships fk_rails_8cd7a9ff0f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT fk_rails_8cd7a9ff0f FOREIGN KEY (membership_tier_id) REFERENCES public.membership_tiers(id);


--
-- Name: canvasses fk_rails_970cf4dbea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.canvasses
    ADD CONSTRAINT fk_rails_970cf4dbea FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: saved_lists fk_rails_99da509c78; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_lists
    ADD CONSTRAINT fk_rails_99da509c78 FOREIGN KEY (created_by_id) REFERENCES public.team_members(id);


--
-- Name: team_members fk_rails_99fbd57ee0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT fk_rails_99fbd57ee0 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: event_shifts fk_rails_aef9f0a57a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_shifts
    ADD CONSTRAINT fk_rails_aef9f0a57a FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: saved_lists fk_rails_b53edc14f5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_lists
    ADD CONSTRAINT fk_rails_b53edc14f5 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: list_folders fk_rails_c9e93bf1f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.list_folders
    ADD CONSTRAINT fk_rails_c9e93bf1f8 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


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
-- Name: canvass_attempts fk_rails_e76622bb9a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.canvass_attempts
    ADD CONSTRAINT fk_rails_e76622bb9a FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: assessment_statuses fk_rails_e7972097ee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_statuses
    ADD CONSTRAINT fk_rails_e7972097ee FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: event_rsvps fk_rails_f67cbc0939; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_rsvps
    ADD CONSTRAINT fk_rails_f67cbc0939 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: saved_lists fk_rails_fa131decaa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_lists
    ADD CONSTRAINT fk_rails_fa131decaa FOREIGN KEY (folder_id) REFERENCES public.list_folders(id);


--
-- Name: assessment_status_changes fk_rails_fb55a185a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_status_changes
    ADD CONSTRAINT fk_rails_fb55a185a3 FOREIGN KEY (changed_by_id) REFERENCES public.team_members(id);


--
-- Name: membership_payments fk_rails_fdcec7ba8b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.membership_payments
    ADD CONSTRAINT fk_rails_fdcec7ba8b FOREIGN KEY (membership_id) REFERENCES public.memberships(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20260920074809'),
('20260920074306'),
('20260920072422'),
('20260920071913'),
('20260919070651'),
('20260919070445'),
('20260919070044'),
('20260919065361'),
('20260919065360'),
('20260919065359'),
('20260918105446'),
('20260918103422'),
('20260918101609');

