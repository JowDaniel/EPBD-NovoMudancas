--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cidade; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cidade (
    nome character varying(100) NOT NULL,
    estado character(2)
);


ALTER TABLE public.cidade OWNER TO postgres;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    codigo integer NOT NULL,
    cpf character(11),
    rg character varying(20),
    nomecompl character varying(100),
    endereco character varying(200)
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- Name: empresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empresa (
    id integer NOT NULL,
    nome character varying(100),
    endereco character varying(200),
    nomecidade character varying(100)
);


ALTER TABLE public.empresa OWNER TO postgres;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.funcionario (
    id integer NOT NULL,
    id_empresa integer NOT NULL,
    nome character varying(100) NOT NULL,
    sobrenome character varying(100) NOT NULL,
    cargo character varying(100) NOT NULL,
    salario numeric(10,2) NOT NULL,
    data_admissao date NOT NULL,
    CONSTRAINT funcionario_salario_check CHECK ((salario >= (0)::numeric))
);


ALTER TABLE public.funcionario OWNER TO postgres;

--
-- Name: funcionario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.funcionario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.funcionario_id_seq OWNER TO postgres;

--
-- Name: funcionario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.funcionario_id_seq OWNED BY public.funcionario.id;


--
-- Name: pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido (
    codigo integer NOT NULL,
    id_cliente integer NOT NULL,
    precototal numeric(10,2) DEFAULT 0,
    id_empresa integer,
    CONSTRAINT pedido_precototal_check CHECK ((precototal >= (0)::numeric))
);


ALTER TABLE public.pedido OWNER TO postgres;

--
-- Name: servicos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servicos (
    nome character varying(100) NOT NULL,
    tempodurac integer,
    preco numeric(10,2),
    id_tipo integer NOT NULL,
    CONSTRAINT servicos_preco_check CHECK ((preco >= (0)::numeric)),
    CONSTRAINT servicos_tempodurac_check CHECK ((tempodurac >= 0))
);


ALTER TABLE public.servicos OWNER TO postgres;

--
-- Name: solicitam; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.solicitam (
    nome character varying(100) NOT NULL,
    codigo integer NOT NULL,
    cpf character(11) NOT NULL,
    tempohoradurac integer,
    preco numeric(10,2),
    datafim date,
    cidadeorigem character varying(100),
    cidadedestino character varying(100),
    id_empresa integer,
    CONSTRAINT solicitam_tempohoradurac_check CHECK ((tempohoradurac >= 0))
);


ALTER TABLE public.solicitam OWNER TO postgres;

--
-- Name: tiposervico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tiposervico (
    id_tipo integer NOT NULL,
    descricao character varying(50)
);


ALTER TABLE public.tiposervico OWNER TO postgres;

--
-- Name: funcionario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcionario ALTER COLUMN id SET DEFAULT nextval('public.funcionario_id_seq'::regclass);


--
-- Data for Name: cidade; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cidade (nome, estado) FROM stdin;
São Paulo	SP
Rio de Janeiro	RJ
Belo Horizonte	MG
\.


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes (codigo, cpf, rg, nomecompl, endereco) FROM stdin;
1	12345678901	123456789	João Silva	Rua A, 123
2	98765432100	234567890	Maria Oliveira	Rua B, 456
3	23456789012	345678901	Carlos Souza	Av. Central, 789
4	34567890123	456789012	Ana Costa	Rua D, 101
5	45678901234	567890123	Pedro Almeida	Rua E, 202
6	56789012345	678901234	Luana Ferreira	Av. Norte, 303
7	67890123456	789012345	Felipe Martins	Rua F, 404
8	78901234567	890123456	Cláudia Ramos	Av. Sul, 505
9	89012345678	901234567	Ricardo Lima	Rua G, 606
10	90123456789	012345678	Mariana Pinto	Av. Oeste, 707
11	01234567890	112233445	Fernanda Rocha	Rua H, 808
12	11223344556	223344556	Giovanni Silva	Rua I, 909
13	22334455667	334455667	Isabela Costa	Rua J, 1010
14	33445566778	445566778	Eduardo Souza	Rua K, 1111
15	44556677889	556677889	Marcos Oliveira	Rua L, 1212
16	55667788990	667788990	Gabriela Almeida	Rua M, 1313
17	66778899001	778899001	Renato Pereira	Rua N, 1414
18	77889900112	889900112	Sandra Lima	Rua O, 1515
19	88990011223	990011223	Flávio Costa	Rua P, 1616
20	99001122334	001122334	Fernanda Alves	Rua Q, 1717
\.


--
-- Data for Name: empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empresa (id, nome, endereco, nomecidade) FROM stdin;
1	Mudanças XYZ	Av. Principal, 456	São Paulo
2	Mudanças ABC	Rua Secundária, 789	Rio de Janeiro
\.


--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.funcionario (id, id_empresa, nome, sobrenome, cargo, salario, data_admissao) FROM stdin;
1	1	João	Silva	Motorista	3000.00	2020-01-15
2	1	Maria	Oliveira	Gerente	4500.00	2019-06-10
3	2	Carlos	Souza	Assistente Administrativo	2500.00	2021-03-20
4	2	Ana	Costa	Motorista	3200.00	2018-08-25
5	1	Pedro	Almeida	Coordenador de Operações	4000.00	2017-12-05
6	2	Luana	Ferreira	Analista de Logística	3500.00	2022-05-15
7	1	Felipe	Martins	Assistente de Campo	2800.00	2023-01-10
8	2	Cláudia	Ramos	Coordenadora de Frota	3800.00	2020-09-17
9	1	Ricardo	Lima	Supervisor de Transporte	4200.00	2016-07-01
10	2	Mariana	Pinto	Analista Financeira	3400.00	2019-11-11
\.


--
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido (codigo, id_cliente, precototal, id_empresa) FROM stdin;
1	1	750.00	1
2	2	1200.00	1
4	4	300.00	2
6	1	850.00	2
7	2	950.00	1
8	3	1200.00	1
9	4	700.00	2
11	1	600.00	1
12	2	650.00	2
13	3	1000.00	2
14	4	850.00	2
15	5	500.00	2
20	10	750.00	2
3	3	1000.00	1
5	5	200.00	1
10	5	900.00	1
16	6	700.00	2
17	7	1200.00	1
18	8	1100.00	2
19	9	450.00	2
\.


--
-- Data for Name: servicos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.servicos (nome, tempodurac, preco, id_tipo) FROM stdin;
Transporte A	5	150.00	1
Transporte B	3	100.00	1
Guindaste C	2	300.00	2
Guindaste D	4	400.00	2
Montagem E	6	200.00	3
Montagem F	2	250.00	3
Desmontagem G	4	250.00	4
Desmontagem H	3	150.00	4
Transporte I	5	120.00	1
Transporte J	3	110.00	1
Transporte C	3	120.00	1
Transporte D	4	130.00	1
Transporte E	3	140.00	1
Transporte F	4	150.00	1
Guindaste E	2	350.00	2
Guindaste F	3	360.00	2
Guindaste G	4	370.00	2
Guindaste H	5	380.00	2
Montagem G	5	210.00	3
Montagem H	6	220.00	3
Montagem I	6	230.00	3
Desmontagem I	4	240.00	4
Desmontagem J	5	250.00	4
\.


--
-- Data for Name: solicitam; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.solicitam (nome, codigo, cpf, tempohoradurac, preco, datafim, cidadeorigem, cidadedestino, id_empresa) FROM stdin;
Montagem E	2	98765432100	6	1200.00	2024-01-15	São Paulo	Rio de Janeiro	1
Transporte A	1	12345678901	5	750.00	2024-01-10	São Paulo	Rio de Janeiro	1
Guindaste C	1	12345678901	2	600.00	2024-01-12	Rio de Janeiro	Belo Horizonte	2
Transporte B	4	34567890123	3	300.00	2024-01-25	Rio de Janeiro	Belo Horizonte	2
Montagem F	6	56789012345	4	1000.00	2024-02-05	Rio de Janeiro	Belo Horizonte	2
Desmontagem H	7	67890123456	5	1200.00	2024-02-10	São Paulo	São Paulo	1
Montagem H	13	22334455667	5	1000.00	2024-03-10	Rio de Janeiro	Rio de Janeiro	2
Transporte E	15	44556677889	3	500.00	2024-03-20	Rio de Janeiro	Rio de Janeiro	2
Guindaste F	12	11223344556	3	650.00	2024-12-12	Rio de Janeiro	Rio de Janeiro	2
Transporte C	8	78901234567	3	350.00	2024-02-15	São Paulo	Rio de Janeiro	1
Transporte D	11	01234567890	4	600.00	2024-03-01	São Paulo	São Paulo	1
Desmontagem I	14	33445566778	4	850.00	2024-03-15	Rio de Janeiro	Rio de Janeiro	2
Guindaste E	9	89012345678	2	600.00	2024-02-20	Rio de Janeiro	São Paulo	2
Guindaste E	20	12345678901	5	750.00	2024-12-12	Rio de Janeiro	São Paulo	2
Guindaste D	5	45678901234	3	900.00	2024-02-01	Belo Horizonte	São Paulo	1
Montagem I	17	66778899001	6	1200.00	2024-04-01	Belo Horizonte	São Paulo	1
Desmontagem G	3	23456789012	4	1000.00	2024-01-20	Belo Horizonte	São Paulo	1
Desmontagem J	18	77889900112	5	1100.00	2024-04-05	Belo Horizonte	Rio de Janeiro	2
Transporte F	19	88990011223	4	450.00	2024-04-10	Belo Horizonte	Rio de Janeiro	2
Guindaste H	20	99001122334	5	750.00	2024-04-15	Belo Horizonte	Rio de Janeiro	2
Montagem G	10	90123456789	5	1050.00	2024-02-25	Belo Horizonte	São Paulo	1
Guindaste G	16	55667788990	4	700.00	2024-03-25	Belo Horizonte	Rio de Janeiro	2
Guindaste E	9	12345678901	\N	600.00	2024-02-15	São Paulo	Rio de Janeiro	2
\.


--
-- Data for Name: tiposervico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tiposervico (id_tipo, descricao) FROM stdin;
1	Transporte
2	Guindaste
3	Montagem
4	Desmontagem
\.


--
-- Name: funcionario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.funcionario_id_seq', 1, false);


--
-- Name: cidade cidade_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cidade
    ADD CONSTRAINT cidade_pkey PRIMARY KEY (nome);


--
-- Name: clientes clientes_cpf_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_cpf_key UNIQUE (cpf);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (codigo);


--
-- Name: clientes clientes_rg_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_rg_key UNIQUE (rg);


--
-- Name: empresa empresa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_pkey PRIMARY KEY (id);


--
-- Name: funcionario funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (id);


--
-- Name: pedido pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (codigo);


--
-- Name: servicos servicos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicos
    ADD CONSTRAINT servicos_pkey PRIMARY KEY (nome);


--
-- Name: solicitam solicitam_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitam
    ADD CONSTRAINT solicitam_pkey PRIMARY KEY (nome, codigo, cpf);


--
-- Name: tiposervico tiposervico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tiposervico
    ADD CONSTRAINT tiposervico_pkey PRIMARY KEY (id_tipo);


--
-- Name: empresa fk_empresa_cidade; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT fk_empresa_cidade FOREIGN KEY (nomecidade) REFERENCES public.cidade(nome) ON DELETE CASCADE;


--
-- Name: pedido fk_pedido_empresa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_pedido_empresa FOREIGN KEY (id_empresa) REFERENCES public.empresa(id) ON DELETE CASCADE;


--
-- Name: servicos fk_servicos_tiposervico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicos
    ADD CONSTRAINT fk_servicos_tiposervico FOREIGN KEY (id_tipo) REFERENCES public.tiposervico(id_tipo) ON DELETE CASCADE;


--
-- Name: solicitam fk_solicitam_cidadedestino; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitam
    ADD CONSTRAINT fk_solicitam_cidadedestino FOREIGN KEY (cidadedestino) REFERENCES public.cidade(nome);


--
-- Name: solicitam fk_solicitam_cidadeorigem; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitam
    ADD CONSTRAINT fk_solicitam_cidadeorigem FOREIGN KEY (cidadeorigem) REFERENCES public.cidade(nome);


--
-- Name: solicitam fk_solicitam_empresa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitam
    ADD CONSTRAINT fk_solicitam_empresa FOREIGN KEY (id_empresa) REFERENCES public.empresa(id) ON DELETE CASCADE;


--
-- Name: funcionario funcionario_id_empresa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_id_empresa_fkey FOREIGN KEY (id_empresa) REFERENCES public.empresa(id) ON DELETE CASCADE;


--
-- Name: pedido pedido_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(codigo) ON DELETE CASCADE;


--
-- Name: servicos servicos_id_tipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicos
    ADD CONSTRAINT servicos_id_tipo_fkey FOREIGN KEY (id_tipo) REFERENCES public.tiposervico(id_tipo);


--
-- Name: solicitam solicitam_codigo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitam
    ADD CONSTRAINT solicitam_codigo_fkey FOREIGN KEY (codigo) REFERENCES public.pedido(codigo) ON DELETE CASCADE;


--
-- Name: solicitam solicitam_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitam
    ADD CONSTRAINT solicitam_cpf_fkey FOREIGN KEY (cpf) REFERENCES public.clientes(cpf) ON DELETE CASCADE;


--
-- Name: solicitam solicitam_nome_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitam
    ADD CONSTRAINT solicitam_nome_fkey FOREIGN KEY (nome) REFERENCES public.servicos(nome) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

