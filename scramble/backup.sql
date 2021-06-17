--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2-YB-2.5.1.0-b0
-- Dumped by pg_dump version 13.3

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
-- Name: ruleframework; Type: SCHEMA; Schema: -; Owner: neo
--

CREATE SCHEMA ruleframework;


ALTER SCHEMA ruleframework OWNER TO neo;

--
-- Name: kpi_type; Type: TYPE; Schema: ruleframework; Owner: neo
--

CREATE TYPE ruleframework.kpi_type AS ENUM (
    'Saturation',
    'Latency',
    'Uptime',
    'Error Rate'
);


ALTER TYPE ruleframework.kpi_type OWNER TO neo;

--
-- Name: metric_operator; Type: TYPE; Schema: ruleframework; Owner: neo
--

CREATE TYPE ruleframework.metric_operator AS ENUM (
    'Equal',
    'Greater than',
    'Greater than equal',
    'Less than',
    'Less than equal'
);


ALTER TYPE ruleframework.metric_operator OWNER TO neo;

--
-- Name: rule_operator; Type: TYPE; Schema: ruleframework; Owner: neo
--

CREATE TYPE ruleframework.rule_operator AS ENUM (
    'AT LEAST ONE',
    'AND',
    'OR'
);


ALTER TYPE ruleframework.rule_operator OWNER TO neo;

--
-- Name: test_category; Type: TYPE; Schema: ruleframework; Owner: neo
--

CREATE TYPE ruleframework.test_category AS ENUM (
    'Network',
    'IT'
);


ALTER TYPE ruleframework.test_category OWNER TO neo;

--
-- Name: test_origin_type; Type: TYPE; Schema: ruleframework; Owner: neo
--

CREATE TYPE ruleframework.test_origin_type AS ENUM (
    'Blackbox',
    'Whitebox'
);


ALTER TYPE ruleframework.test_origin_type OWNER TO neo;

--
-- Name: test_type; Type: TYPE; Schema: ruleframework; Owner: neo
--

CREATE TYPE ruleframework.test_type AS ENUM (
    'Regular',
    'Aggregation'
);


ALTER TYPE ruleframework.test_type OWNER TO neo;

--
-- Name: threshold_type; Type: TYPE; Schema: ruleframework; Owner: neo
--

CREATE TYPE ruleframework.threshold_type AS ENUM (
    'Green',
    'Yellow',
    'Red'
);


ALTER TYPE ruleframework.threshold_type OWNER TO neo;

SET default_tablespace = '';

--
-- Name: fuctionalities; Type: TABLE; Schema: ruleframework; Owner: neo
--

CREATE TABLE ruleframework.fuctionalities (
    id uuid NOT NULL,
    name character varying,
    category public.test_category
);


ALTER TABLE ruleframework.fuctionalities OWNER TO neo;

--
-- Name: functionality_thresholds; Type: TABLE; Schema: ruleframework; Owner: neo
--

CREATE TABLE ruleframework.functionality_thresholds (
    id uuid NOT NULL,
    test_threshold_id uuid NOT NULL,
    functionality_id uuid NOT NULL,
    type ruleframework.threshold_type NOT NULL,
    rule ruleframework.rule_operator NOT NULL
);


ALTER TABLE ruleframework.functionality_thresholds OWNER TO neo;

--
-- Name: service; Type: TABLE; Schema: ruleframework; Owner: neo
--

CREATE TABLE ruleframework.service (
    id uuid NOT NULL,
    name character varying,
    category public.test_category
);


ALTER TABLE ruleframework.service OWNER TO neo;

--
-- Name: service_thresholds; Type: TABLE; Schema: ruleframework; Owner: neo
--

CREATE TABLE ruleframework.service_thresholds (
    id uuid NOT NULL,
    functionality_threshold_id uuid NOT NULL,
    service_id uuid NOT NULL,
    type ruleframework.threshold_type NOT NULL,
    rule ruleframework.rule_operator NOT NULL
);


ALTER TABLE ruleframework.service_thresholds OWNER TO neo;

--
-- Name: test_results; Type: TABLE; Schema: ruleframework; Owner: neo
--

CREATE TABLE ruleframework.test_results (
    id uuid NOT NULL,
    "timestamp" timestamp(0) without time zone DEFAULT now() NOT NULL,
    success_rate real
);


ALTER TABLE ruleframework.test_results OWNER TO neo;

--
-- Name: test_thresholds; Type: TABLE; Schema: ruleframework; Owner: neo
--

CREATE TABLE ruleframework.test_thresholds (
    id uuid NOT NULL,
    testid uuid NOT NULL,
    threshold_rate real,
    type ruleframework.threshold_type,
    operator ruleframework.metric_operator
);


ALTER TABLE ruleframework.test_thresholds OWNER TO neo;

--
-- Name: tests; Type: TABLE; Schema: ruleframework; Owner: neo
--

CREATE TABLE ruleframework.tests (
    id uuid NOT NULL,
    name character varying,
    type public.test_type DEFAULT 'Regular'::public.test_type,
    category public.test_category,
    kpi_type ruleframework.kpi_type DEFAULT 'Uptime'::ruleframework.kpi_type,
    origin_type public.test_origin_type DEFAULT 'Whitebox'::public.test_origin_type
);


ALTER TABLE ruleframework.tests OWNER TO neo;

--
-- Name: fuctionalities fuctionalities_pk; Type: CONSTRAINT; Schema: ruleframework; Owner: neo
--

ALTER TABLE ONLY ruleframework.fuctionalities
    ADD CONSTRAINT fuctionalities_pk PRIMARY KEY (id);


--
-- Name: functionality_thresholds functionality_thresholds_pkey; Type: CONSTRAINT; Schema: ruleframework; Owner: neo
--

ALTER TABLE ONLY ruleframework.functionality_thresholds
    ADD CONSTRAINT functionality_thresholds_pkey PRIMARY KEY (id);


--
-- Name: service service_pk; Type: CONSTRAINT; Schema: ruleframework; Owner: neo
--

ALTER TABLE ONLY ruleframework.service
    ADD CONSTRAINT service_pk PRIMARY KEY (id);


--
-- Name: service_thresholds service_thresholds_pk; Type: CONSTRAINT; Schema: ruleframework; Owner: neo
--

ALTER TABLE ONLY ruleframework.service_thresholds
    ADD CONSTRAINT service_thresholds_pk PRIMARY KEY (id);


--
-- Name: test_thresholds test_thresholds_pk; Type: CONSTRAINT; Schema: ruleframework; Owner: neo
--

ALTER TABLE ONLY ruleframework.test_thresholds
    ADD CONSTRAINT test_thresholds_pk PRIMARY KEY (id);


--
-- Name: tests tests_pkey; Type: CONSTRAINT; Schema: ruleframework; Owner: neo
--

ALTER TABLE ONLY ruleframework.tests
    ADD CONSTRAINT tests_pkey PRIMARY KEY (id);


--
-- Name: functionality_thresholds functionality_thresholds_fk; Type: FK CONSTRAINT; Schema: ruleframework; Owner: neo
--

ALTER TABLE ONLY ruleframework.functionality_thresholds
    ADD CONSTRAINT functionality_thresholds_fk FOREIGN KEY (functionality_id) REFERENCES ruleframework.fuctionalities(id);


--
-- Name: functionality_thresholds functionality_thresholds_fk_1; Type: FK CONSTRAINT; Schema: ruleframework; Owner: neo
--

ALTER TABLE ONLY ruleframework.functionality_thresholds
    ADD CONSTRAINT functionality_thresholds_fk_1 FOREIGN KEY (test_threshold_id) REFERENCES ruleframework.test_thresholds(id);


--
-- Name: service_thresholds service_thresholds_fk_1; Type: FK CONSTRAINT; Schema: ruleframework; Owner: neo
--

ALTER TABLE ONLY ruleframework.service_thresholds
    ADD CONSTRAINT service_thresholds_fk_1 FOREIGN KEY (functionality_threshold_id) REFERENCES ruleframework.functionality_thresholds(id);


--
-- Name: service_thresholds service_thresholds_fk_2; Type: FK CONSTRAINT; Schema: ruleframework; Owner: neo
--

ALTER TABLE ONLY ruleframework.service_thresholds
    ADD CONSTRAINT service_thresholds_fk_2 FOREIGN KEY (service_id) REFERENCES ruleframework.service(id);


--
-- Name: test_results test_results_fk; Type: FK CONSTRAINT; Schema: ruleframework; Owner: neo
--

ALTER TABLE ONLY ruleframework.test_results
    ADD CONSTRAINT test_results_fk FOREIGN KEY (id) REFERENCES ruleframework.tests(id);


--
-- Name: test_thresholds test_thresholds_fk_1; Type: FK CONSTRAINT; Schema: ruleframework; Owner: neo
--

ALTER TABLE ONLY ruleframework.test_thresholds
    ADD CONSTRAINT test_thresholds_fk_1 FOREIGN KEY (testid) REFERENCES ruleframework.tests(id);


--
-- PostgreSQL database dump complete
--

