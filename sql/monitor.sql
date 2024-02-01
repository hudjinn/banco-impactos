--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg110+1)
-- Dumped by pg_dump version 16.1 (Debian 16.1-1.pgdg110+1)

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
-- Name: monitor; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA monitor;


ALTER SCHEMA monitor OWNER TO postgres;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- Name: reset_sequence_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.reset_sequence_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sua lógica aqui
    NEW.id = COALESCE((SELECT MAX(id) + 1 FROM monitor.impactos_seca WHERE cod_mun = NEW.cod_mun AND ano_mes = NEW.ano_mes), 0);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.reset_sequence_trigger() OWNER TO postgres;

--
-- Name: valida_problema_restricao_func(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.valida_problema_restricao_func(problema_restricao integer[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Retorna TRUE se todos os valores em problema_restricao existirem em problema_restricao
  RETURN NOT EXISTS (SELECT 1 FROM unnest(problema_restricao) pr WHERE NOT EXISTS (SELECT 1 FROM monitor.problema_restricao WHERE id_problema_restricao = pr));
END;
$$;


ALTER FUNCTION public.valida_problema_restricao_func(problema_restricao integer[]) OWNER TO postgres;

--
-- Name: valida_tipo_cultura_func(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.valida_tipo_cultura_func(tipo_cultura integer[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Retorna TRUE se todos os valores em tipo_cultura existirem em tipo_cultura
  RETURN NOT EXISTS (SELECT 1 FROM unnest(tipo_cultura) tc WHERE NOT EXISTS (SELECT 1 FROM monitor.tipo_cultura WHERE id_tipo_cultura = tc));
END;
$$;


ALTER FUNCTION public.valida_tipo_cultura_func(tipo_cultura integer[]) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: acesso_agua; Type: TABLE; Schema: monitor; Owner: postgres
--

CREATE TABLE monitor.acesso_agua (
    id_acesso_agua integer NOT NULL,
    acesso_agua character varying NOT NULL
);


ALTER TABLE monitor.acesso_agua OWNER TO postgres;

--
-- Name: de_chuva; Type: TABLE; Schema: monitor; Owner: postgres
--

CREATE TABLE monitor.de_chuva (
    id_de_chuva integer NOT NULL,
    de_chuva character varying NOT NULL
);


ALTER TABLE monitor.de_chuva OWNER TO postgres;

--
-- Name: dt_chuva; Type: TABLE; Schema: monitor; Owner: postgres
--

CREATE TABLE monitor.dt_chuva (
    id_dt_chuva integer NOT NULL,
    dt_chuva character varying NOT NULL
);


ALTER TABLE monitor.dt_chuva OWNER TO postgres;

--
-- Name: impactos_seca; Type: TABLE; Schema: monitor; Owner: postgres
--

CREATE TABLE monitor.impactos_seca (
    id integer NOT NULL,
    cod_mun integer NOT NULL,
    ano_mes integer NOT NULL,
    qnt_chuva integer NOT NULL,
    percepcao_seca integer NOT NULL,
    dt_chuva integer NOT NULL,
    de_chuva integer NOT NULL,
    tipo_cultura integer[] NOT NULL,
    sit_cultura integer NOT NULL,
    acesso_agua integer NOT NULL,
    problema_restricao integer[] NOT NULL,
    dt_inclusao date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT valida_problema_restricao CHECK (public.valida_problema_restricao_func(problema_restricao)),
    CONSTRAINT valida_tipo_cultura CHECK (public.valida_tipo_cultura_func(tipo_cultura))
);


ALTER TABLE monitor.impactos_seca OWNER TO postgres;

--
-- Name: impactos_seca_id_seq; Type: SEQUENCE; Schema: monitor; Owner: postgres
--

CREATE SEQUENCE monitor.impactos_seca_id_seq
    AS integer
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 9999
    CACHE 1;


ALTER SEQUENCE monitor.impactos_seca_id_seq OWNER TO postgres;

--
-- Name: impactos_seca_id_seq; Type: SEQUENCE OWNED BY; Schema: monitor; Owner: postgres
--

ALTER SEQUENCE monitor.impactos_seca_id_seq OWNED BY monitor.impactos_seca.id;


--
-- Name: limites_estaduais_ibge_2022; Type: TABLE; Schema: monitor; Owner: postgres
--

CREATE TABLE monitor.limites_estaduais_ibge_2022 (
    cod_uf bigint NOT NULL,
    nome_uf character varying(50),
    sigla_uf character varying(2),
    nome_regiao character varying(20),
    area_km2 double precision
);


ALTER TABLE monitor.limites_estaduais_ibge_2022 OWNER TO postgres;

--
-- Name: TABLE limites_estaduais_ibge_2022; Type: COMMENT; Schema: monitor; Owner: postgres
--

COMMENT ON TABLE monitor.limites_estaduais_ibge_2022 IS 'Limites Estaduais fornecidos pelo IBGE, Base 2022';


--
-- Name: limites_municipais_ibge_2022; Type: TABLE; Schema: monitor; Owner: postgres
--

CREATE TABLE monitor.limites_municipais_ibge_2022 (
    cod_mun integer NOT NULL,
    nome_mun character varying(50),
    sigla_uf character varying(2),
    area_km2 double precision
);


ALTER TABLE monitor.limites_municipais_ibge_2022 OWNER TO postgres;

--
-- Name: TABLE limites_municipais_ibge_2022; Type: COMMENT; Schema: monitor; Owner: postgres
--

COMMENT ON TABLE monitor.limites_municipais_ibge_2022 IS 'Obtido no IBGE, base 2022';


--
-- Name: percepcao_seca; Type: TABLE; Schema: monitor; Owner: postgres
--

CREATE TABLE monitor.percepcao_seca (
    id_percepcao_seca integer NOT NULL,
    percepcao_seca character varying NOT NULL
);


ALTER TABLE monitor.percepcao_seca OWNER TO postgres;

--
-- Name: problema_restricao; Type: TABLE; Schema: monitor; Owner: postgres
--

CREATE TABLE monitor.problema_restricao (
    id_problema_restricao integer NOT NULL,
    problema_restricao character varying NOT NULL
);


ALTER TABLE monitor.problema_restricao OWNER TO postgres;

--
-- Name: qnt_chuva; Type: TABLE; Schema: monitor; Owner: postgres
--

CREATE TABLE monitor.qnt_chuva (
    id_qnt_chuva integer NOT NULL,
    qnt_chuva character varying NOT NULL
);


ALTER TABLE monitor.qnt_chuva OWNER TO postgres;

--
-- Name: sit_cultura; Type: TABLE; Schema: monitor; Owner: postgres
--

CREATE TABLE monitor.sit_cultura (
    id_sit_cultura integer NOT NULL,
    sit_cultura character varying NOT NULL
);


ALTER TABLE monitor.sit_cultura OWNER TO postgres;

--
-- Name: tipo_cultura; Type: TABLE; Schema: monitor; Owner: postgres
--

CREATE TABLE monitor.tipo_cultura (
    id_tipo_cultura integer NOT NULL,
    tipo_cultura character varying NOT NULL
);


ALTER TABLE monitor.tipo_cultura OWNER TO postgres;

--
-- Name: view_impactos_seca; Type: VIEW; Schema: monitor; Owner: postgres
--

CREATE VIEW monitor.view_impactos_seca AS
SELECT
    NULL::integer AS id,
    NULL::integer AS cod_mun,
    NULL::character varying(50) AS nome_mun,
    NULL::character varying(2) AS uf,
    NULL::integer AS ano_mes,
    NULL::character varying AS distr_temp_chuva,
    NULL::character varying AS distr_espac_chuva,
    NULL::character varying AS percepcao_seca,
    NULL::character varying AS qnt_chuva,
    NULL::character varying AS sit_cultura,
    NULL::character varying[] AS tipo_cultura,
    NULL::character varying[] AS problema_restricao,
    NULL::date AS dt_inclusao;


ALTER VIEW monitor.view_impactos_seca OWNER TO postgres;

--
-- Name: view_impactos_seca_with_values; Type: VIEW; Schema: monitor; Owner: postgres
--

CREATE VIEW monitor.view_impactos_seca_with_values AS
SELECT
    NULL::integer AS id,
    NULL::integer AS cod_mun,
    NULL::character varying(50) AS nome_mun,
    NULL::character varying(2) AS uf,
    NULL::integer AS ano_mes,
    NULL::integer AS id_dt_chuva,
    NULL::character varying AS distr_temp_chuva,
    NULL::integer AS id_de_chuva,
    NULL::character varying AS distr_espac_chuva,
    NULL::integer AS id_percepcao_seca,
    NULL::character varying AS percepcao_seca,
    NULL::integer AS id_qnt_chuva,
    NULL::character varying AS qnt_chuva,
    NULL::character varying AS sit_cultura,
    NULL::integer[] AS id_tipo_cultura,
    NULL::character varying[] AS tipo_cultura,
    NULL::integer[] AS id_problema_restricao,
    NULL::character varying[] AS problema_restricao,
    NULL::date AS dt_inclusao;


ALTER VIEW monitor.view_impactos_seca_with_values OWNER TO postgres;

--
-- Name: impactos_seca id; Type: DEFAULT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.impactos_seca ALTER COLUMN id SET DEFAULT nextval('monitor.impactos_seca_id_seq'::regclass);


--
-- Data for Name: acesso_agua; Type: TABLE DATA; Schema: monitor; Owner: postgres
--

COPY monitor.acesso_agua (id_acesso_agua, acesso_agua) FROM stdin;
1	Nenhum problema
2	Níveis baixos, mas sem problemas
3	Níveis baixos e alguns usos afetados
4	Níveis muito baixos e há restrições de uso
5	Níveis críticos e restrições severas
6	Sistemas hídricos em colapso/Falta d'água generalizada
99	Não sei informar
\.


--
-- Data for Name: de_chuva; Type: TABLE DATA; Schema: monitor; Owner: postgres
--

COPY monitor.de_chuva (id_de_chuva, de_chuva) FROM stdin;
1	Não choveu
2	Chuva isolada
3	Chuva abrangente
99	Não sei avaliar
\.


--
-- Data for Name: dt_chuva; Type: TABLE DATA; Schema: monitor; Owner: postgres
--

COPY monitor.dt_chuva (id_dt_chuva, dt_chuva) FROM stdin;
1	Não choveu
2	Menos de 10 dias
3	Mais de 10 dias
99	Não sei avaliar
\.


--
-- Data for Name: impactos_seca; Type: TABLE DATA; Schema: monitor; Owner: postgres
--

COPY monitor.impactos_seca (id, cod_mun, ano_mes, qnt_chuva, percepcao_seca, dt_chuva, de_chuva, tipo_cultura, sit_cultura, acesso_agua, problema_restricao, dt_inclusao) FROM stdin;
\.


--
-- Data for Name: limites_estaduais_ibge_2022; Type: TABLE DATA; Schema: monitor; Owner: postgres
--

COPY monitor.limites_estaduais_ibge_2022 (cod_uf, nome_uf, sigla_uf, nome_regiao, area_km2) FROM stdin;
12	Acre	AC	Norte	164173.429
13	Amazonas	AM	Norte	1559255.881
15	Pará	PA	Norte	1245870.704
16	Amapá	AP	Norte	142470.762
17	Tocantins	TO	Norte	277423.627
21	Maranhão	MA	Nordeste\n	329651.496
22	Piauí	PI	Nordeste\n	251755.481
23	Ceará	CE	Nordeste\n	148894.447
24	Rio Grande do Norte	RN	Nordeste\n	52809.599
25	Paraíba	PB	Nordeste\n	56467.242
26	Pernambuco	PE	Nordeste\n	98067.877
27	Alagoas	AL	Nordeste\n	27830.661
28	Sergipe	SE	Nordeste\n	21938.188
29	Bahia	BA	Nordeste\n	564760.429
31	Minas Gerais	MG	Sudeste\n	586513.983
32	Espírito Santo	ES	Sudeste\n	46074.448
33	Rio de Janeiro	RJ	Sudeste\n	43750.425
35	São Paulo	SP	Sudeste\n	248219.485
41	Paraná	PR	Sul\n	199298.981
42	Santa Catarina	SC	Sul\n	95730.69
43	Rio Grande do Sul	RS	Sul\n	281707.151
50	Mato Grosso do Sul	MS	Centro-oeste\n	357142.082
51	Mato Grosso	MT	Centro-oeste\n	903208.361
52	Goiás	GO	Centro-oeste\n	340242.859
53	Distrito Federal	DF	Centro-oeste\n	5760.784
11	Rondônia	RO	Norte	237754.172
14	Roraima	RR	Norte	223644.53
\.


--
-- Data for Name: limites_municipais_ibge_2022; Type: TABLE DATA; Schema: monitor; Owner: postgres
--

COPY monitor.limites_municipais_ibge_2022 (cod_mun, nome_mun, sigla_uf, area_km2) FROM stdin;
1100015	Alta Floresta D'Oeste	RO	7067.127
1100023	Ariquemes	RO	4426.571
1100031	Cabixi	RO	1314.352
1100049	Cacoal	RO	3793
1100056	Cerejeiras	RO	2783.3
1101559	Teixeirópolis	RO	459.978
1100064	Colorado do Oeste	RO	1451.06
1100072	Corumbiara	RO	3060.321
1100080	Costa Marques	RO	4987.177
1100098	Espigão D'Oeste	RO	4518.038
1100106	Guajará-Mirim	RO	24856.877
1100114	Jaru	RO	2944.128
1100122	Ji-Paraná	RO	6896.649
1100130	Machadinho D'Oeste	RO	8509.27
1100148	Nova Brasilândia D'Oeste	RO	1703.008
1101609	Theobroma	RO	2197.413
2405900	João Dias	RN	88.173
3510005	Cândido Mota	SP	595.811
4216305	São João Batista	SC	200.765
4216354	São João do Itaperiú	SC	151.885
1100155	Ouro Preto do Oeste	RO	1969.85
1100189	Pimenta Bueno	RO	6241.016
1100205	Porto Velho	RO	34090.952
1100254	Presidente Médici	RO	1758.465
1100262	Rio Crespo	RO	1717.64
1100288	Rolim de Moura	RO	1457.811
1301803	Ipixuna	AM	12109.779
1100296	Santa Luzia D'Oeste	RO	1197.796
1100304	Vilhena	RO	11699.15
1100320	São Miguel do Guaporé	RO	7460.117
1100338	Nova Mamoré	RO	10070.49
1100346	Alvorada D'Oeste	RO	3029.189
1100379	Alto Alegre dos Parecis	RO	3958.273
1100403	Alto Paraíso	RO	2651.822
1100452	Buritis	RO	3265.809
1301852	Iranduba	AM	2216.817
1301902	Itacoatiara	AM	8891.906
1301951	Itamarati	AM	25260.429
1302009	Itapiranga	AM	4335.075
1302108	Japurá	AM	55827.203
1302207	Juruá	AM	19442.548
1302306	Jutaí	AM	69457.415
1302405	Lábrea	AM	68262.68
1302504	Manacapuru	AM	7336.579
1302553	Manaquiri	AM	3973.258
1302603	Manaus	AM	11401.092
1302702	Manicoré	AM	48315.038
1302801	Maraã	AM	16830.827
1302900	Maués	AM	39991.066
1303007	Nhamundá	AM	14107.04
1303106	Nova Olinda do Norte	AM	5578.132
1303205	Novo Airão	AM	37776.77
1303304	Novo Aripuanã	AM	41179.656
1303403	Parintins	AM	5956.047
1303502	Pauini	AM	41624.664
1303536	Presidente Figueiredo	AM	25459.099
1303569	Rio Preto da Eva	AM	5815.622
1303601	Santa Isabel do Rio Negro	AM	62800.078
1303700	Santo Antônio do Içá	AM	12366.214
1303809	São Gabriel da Cachoeira	AM	109192.562
1303908	São Paulo de Olivença	AM	19658.502
1303957	São Sebastião do Uatumã	AM	10647.463
1304005	Silves	AM	3723.382
1304062	Tabatinga	AM	3260.103
1304104	Tapauá	AM	84946.035
1304203	Tefé	AM	23692.223
1304237	Tonantins	AM	6446.894
1304260	Uarini	AM	10274.677
1304302	Urucará	AM	27901.962
1304401	Urucurituba	AM	2886.494
1400027	Amajari	RR	28473.45
1400050	Alto Alegre	RR	25454.297
1400100	Boa Vista	RR	5687.037
1400159	Bonfim	RR	8079.914
1400175	Cantá	RR	7664.831
1400209	Caracaraí	RR	47379.903
1400233	Caroebe	RR	12065.896
1400282	Iracema	RR	14011.695
1100502	Novo Horizonte do Oeste	RO	843.446
1400308	Mucajaí	RR	12337.851
1400407	Normandia	RR	6959.868
1400456	Pacaraima	RR	8025.045
1400472	Rorainópolis	RR	33579.739
1400506	São João da Baliza	RR	4284.505
2408805	Parazinho	RN	231.007
3515301	Estrela do Norte	SP	264.987
4216404	São João do Sul	SC	184.375
4216503	São Joaquim	SC	1888.634
4216602	São José	SC	150.499
1100601	Cacaulândia	RO	1961.778
1100700	Campo Novo de Rondônia	RO	3442.005
1100809	Candeias do Jamari	RO	6843.868
1502608	Colares	PA	384.068
1502707	Conceição do Araguaia	PA	5829.482
1502756	Concórdia do Pará	PA	700.59
1100908	Castanheiras	RO	892.841
1100924	Chupinguaia	RO	5126.723
1100940	Cujubim	RO	3863.946
1101005	Governador Jorge Teixeira	RO	5067.384
1101104	Itapuã do Oeste	RO	4081.58
1101203	Ministro Andreazza	RO	798.083
1101302	Mirante da Serra	RO	1191.875
1101401	Monte Negro	RO	1931.378
1101435	Nova União	RO	807.125
1101450	Parecis	RO	2548.683
1101468	Pimenteiras do Oeste	RO	6014.733
1502764	Cumaru do Norte	PA	17085.001
1502772	Curionópolis	PA	2369.096
3515707	Ferraz de Vasconcelos	SP	29.547
3515806	Flora Rica	SP	224.711
3515905	Floreal	SP	204.236
1101476	Primavera de Rondônia	RO	605.692
1101484	São Felipe D'Oeste	RO	541.647
1101492	São Francisco do Guaporé	RO	10948.593
1101500	Seringueiras	RO	3773.505
3516002	Flórida Paulista	SP	524.138
4216701	São José do Cedro	SC	280.76
4216800	São José do Cerrito	SC	948.714
1101708	Urupá	RO	831.857
1101757	Vale do Anari	RO	3135.106
2100105	Afonso Cunha	MA	371.338
2100154	Água Doce do Maranhão	MA	442.292
1101807	Vale do Paraíso	RO	965.676
1200013	Acrelândia	AC	1811.613
1200054	Assis Brasil	AC	4979.073
1200104	Brasiléia	AC	3928.174
1200138	Bujari	AC	3034.869
1200179	Capixaba	AC	1705.824
1200203	Cruzeiro do Sul	AC	8783.47
1200252	Epitaciolândia	AC	1652.674
1200302	Feijó	AC	27976.874
1200328	Jordão	AC	5357.227
1200336	Mâncio Lima	AC	5451.617
1200344	Manoel Urbano	AC	10630.6
1200351	Marechal Thaumaturgo	AC	8190.953
1200385	Plácido de Castro	AC	1952.555
1200393	Porto Walter	AC	6446.385
1200401	Rio Branco	AC	8835.154
1200427	Rodrigues Alves	AC	3076.342
1200435	Santa Rosa do Purus	AC	6155.858
1200450	Senador Guiomard	AC	2320.169
1200500	Sena Madureira	AC	23759.512
1200609	Tarauacá	AC	20169.485
1200708	Xapuri	AC	5350.586
1200807	Porto Acre	AC	2604.417
1300029	Alvarães	AM	5923.461
1300060	Amaturá	AM	4754.109
1300086	Anamã	AM	2446.121
1300102	Anori	AM	6036.38
1300144	Apuí	AM	54240.545
1300201	Atalaia do Norte	AM	76507.617
1300300	Autazes	AM	7652.852
1300409	Barcelos	AM	122461.086
1300508	Barreirinha	AM	5751.765
1300607	Benjamin Constant	AM	8705.441
1300631	Beruri	AM	17472.779
1300680	Boa Vista do Ramos	AM	2589.407
1300706	Boca do Acre	AM	21938.583
1300805	Borba	AM	44236.184
1300839	Caapiranga	AM	9455.539
1300904	Canutama	AM	33642.732
1301001	Carauari	AM	25778.658
1301100	Careiro	AM	6096.212
1301159	Careiro da Várzea	AM	2627.474
1301209	Coari	AM	57970.768
1301308	Codajás	AM	18700.713
1301407	Eirunepé	AM	14966.242
1301506	Envira	AM	7505.794
1301605	Fonte Boa	AM	12155.427
1301654	Guajará	AM	7583.534
1301704	Humaitá	AM	33111.129
1400605	São Luiz	RR	1526.898
1400704	Uiramutã	RR	8113.598
1500107	Abaetetuba	PA	1610.654
1500131	Abel Figueiredo	PA	614.131
1500206	Acará	PA	4344.384
1500305	Afuá	PA	8338.438
1500347	Água Azul do Norte	PA	7113.955
1500404	Alenquer	PA	23645.452
1500503	Almeirim	PA	72954.798
1500602	Altamira	PA	159533.306
1500701	Anajás	PA	6913.64
1500800	Ananindeua	PA	190.581
1500859	Anapu	PA	11895.27
1500909	Augusto Corrêa	PA	1099.619
1500958	Aurora do Pará	PA	1811.84
1501006	Aveiro	PA	17074.053
1501105	Bagre	PA	4397.321
1501204	Baião	PA	3759.834
1501253	Bannach	PA	2956.649
1501303	Barcarena	PA	1310.338
1501402	Belém	PA	1059.466
1501451	Belterra	PA	4398.418
2100204	Alcântara	MA	1167.964
3516606	Gália	SP	355.914
3516705	Garça	SP	555.807
3516804	Gastão Vidigal	SP	180.569
3516853	Gavião Peixoto	SP	243.766
3516903	General Salgado	SP	494.376
3517000	Getulina	SP	676.755
3517109	Glicério	SP	272.8
3517208	Guaiçara	SP	277.154
3517307	Guaimbê	SP	217.811
3517406	Guaíra	SP	1258.465
3517505	Guapiaçu	SP	325.126
3517604	Guapiara	SP	408.292
3517703	Guará	SP	362.183
3517802	Guaraçaí	SP	569.197
1501501	Benevides	PA	187.826
1501576	Bom Jesus do Tocantins	PA	2816.604
1501600	Bonito	PA	586.976
1501709	Bragança	PA	2124.734
1501725	Brasil Novo	PA	6362.575
2204907	Isaías Coelho	PI	800.688
3517901	Guaraci	SP	641.501
4216909	São Lourenço do Oeste	SC	356.193
1501758	Brejo Grande do Araguaia	PA	1288.477
2406007	José da Penha	RN	117.635
3518800	Guarulhos	SP	318.675
3518859	Guatapará	SP	413.567
1501782	Breu Branco	PA	3941.904
1501808	Breves	PA	9566.572
1501907	Bujaru	PA	994.691
1501956	Cachoeira do Piriá	PA	2419.6
1502004	Cachoeira do Arari	PA	3100.261
1502103	Cametá	PA	3081.367
1502152	Canaã dos Carajás	PA	3146.821
1502202	Capanema	PA	621.483
1502301	Capitão Poço	PA	2901.026
1502400	Castanhal	PA	1029.3
1502509	Chaves	PA	12534.995
3518909	Guzolândia	SP	252.477
3519006	Herculândia	SP	364.252
4217006	São Ludgero	SC	106.765
4217105	São Martinho	SC	224.566
4217154	São Miguel da Boa Vista	SC	72.755
4217204	São Miguel do Oeste	SC	234.202
4217253	São Pedro de Alcântara	SC	139.196
1502806	Curralinho	PA	3617.252
1502855	Curuá	PA	1431.134
1502905	Curuçá	PA	676.322
1502939	Dom Eliseu	PA	5268.809
3519600	Ibitinga	SP	689.391
3519709	Ibiúna	SP	1058.082
1502954	Eldorado do Carajás	PA	2956.691
1503002	Faro	PA	11771.669
1503044	Floresta do Araguaia	PA	3444.285
1503077	Garrafão do Norte	PA	1608.014
1503093	Goianésia do Pará	PA	7023.948
1503101	Gurupá	PA	8570.286
3519808	Icém	SP	362.355
3519907	Iepê	SP	594.974
3520004	Igaraçu do Tietê	SP	97.747
3520103	Igarapava	SP	468.355
3520202	Igaratá	SP	292.953
3520301	Iguape	SP	1978.795
3520400	Ilhabela	SP	346.389
3520426	Ilha Comprida	SP	196.567
3520442	Ilha Solteira	SP	652.641
1503200	Igarapé-Açu	PA	785.983
1503309	Igarapé-Miri	PA	1996.79
1503408	Inhangapi	PA	472.605
1503457	Ipixuna do Pará	PA	5215.555
1503507	Irituia	PA	1385.209
1503606	Itaituba	PA	62042.472
1503705	Itupiranga	PA	7880.109
1503754	Jacareacanga	PA	53304.563
2100550	Amapá do Maranhão	MA	502.402
2100600	Amarante do Maranhão	MA	7439.615
2100709	Anajatuba	MA	940.489
1503804	Jacundá	PA	2008.315
2100808	Anapurus	MA	608.903
1503903	Juruti	PA	8305.454
1505007	Nova Timboteua	PA	489.853
1504000	Limoeiro do Ajuru	PA	1490.186
1504059	Mãe do Rio	PA	469.341
1505031	Novo Progresso	PA	38162.002
1505064	Novo Repartimento	PA	15398.723
1505106	Óbidos	PA	28011.041
1505205	Oeiras do Pará	PA	3852.291
1505304	Oriximiná	PA	107613.838
1505403	Ourém	PA	561.71
1505437	Ourilândia do Norte	PA	14410.567
1505486	Pacajá	PA	11832.323
2100832	Apicum-Açu	MA	341.12
2100873	Araguanã	MA	805.194
2100907	Araioses	MA	1789.73
2100956	Arame	MA	2976.039
2101004	Arari	MA	1100.275
3520509	Indaiatuba	SP	311.545
3520608	Indiana	SP	129.367
4217303	Saudades	SC	205.781
4217402	Schroeder	SC	165.237
4217501	Seara	SC	309.627
4217550	Serra Alta	SC	90.564
4217600	Siderópolis	SC	262.004
4217709	Sombrio	SC	143.457
4217758	Sul Brasil	SC	113.125
4217808	Taió	SC	693.847
4217907	Tangará	SC	390.044
4217956	Tigrinhos	SC	56.962
4218004	Tijucas	SC	279.159
4218103	Timbé do Sul	SC	328.507
4218202	Timbó	SC	128.313
1504109	Magalhães Barata	PA	323.984
1504208	Marabá	PA	15128.058
1504307	Maracanã	PA	807.628
1504406	Marapanim	PA	804.625
1506559	Santa Luzia do Pará	PA	1346.502
1506583	Santa Maria das Barreiras	PA	10330.214
1506609	Santa Maria do Pará	PA	457.724
1506708	Santana do Araguaia	PA	11591.441
1506807	Santarém	PA	17898.389
2210300	São Julião	PI	291.089
1504422	Marituba	PA	103.214
1504455	Medicilândia	PA	8272.629
1504505	Melgaço	PA	6774.065
1504604	Mocajuba	PA	871.171
1504703	Moju	PA	9094.139
1504752	Mojuí dos Campos	PA	4988.236
1504802	Monte Alegre	PA	18152.559
1504901	Muaná	PA	3763.337
1504950	Nova Esperança do Piriá	PA	2808.195
2210359	São Lourenço do Piauí	PI	673.822
3520806	Inúbia Paulista	SP	87.119
4218251	Timbó Grande	SC	596.344
1504976	Nova Ipixuna	PA	1564.184
3522604	Itapira	SP	518.416
3522653	Itapirapuã Paulista	SP	406.478
3522703	Itápolis	SP	996.747
3522802	Itaporanga	SP	507.997
4218301	Três Barras	SC	436.496
4218350	Treviso	SC	156.61
4218400	Treze de Maio	SC	159.833
4218509	Treze Tílias	SC	185.937
4218608	Trombudo Central	SC	109.648
4218707	Tubarão	SC	301.485
4218756	Tunápolis	SC	132.939
1505494	Palestina do Pará	PA	984.362
1505502	Paragominas	PA	19342.565
1505536	Parauapebas	PA	6885.794
1505551	Pau D'Arco	PA	1671.419
1505601	Peixe-Boi	PA	450.224
3525003	Jandira	SP	17.449
3525102	Jardinópolis	SP	501.87
3525201	Jarinu	SP	207.549
3525300	Jaú	SP	687.103
3525409	Jeriquara	SP	141.971
3525508	Joanópolis	SP	374.293
3525607	João Ramalho	SP	415.452
3525706	José Bonifácio	SP	860.2
3525805	Júlio Mesquita	SP	128.183
4218806	Turvo	SC	235.104
4218855	União do Oeste	SC	92.857
1505635	Piçarra	PA	3312.708
1505650	Placas	PA	7173.194
1505700	Ponta de Pedras	PA	3363.749
1505809	Portel	PA	25384.96
1505908	Porto de Moz	PA	17423.017
1506005	Prainha	PA	14786.953
2406205	Lagoa d'Anta	RN	105.652
3527256	Lourdes	SP	113.94
3527306	Louveira	SP	55.738
3527405	Lucélia	SP	314.81
3527504	Lucianópolis	SP	189.536
3527603	Luís Antônio	SP	598.257
3527702	Luiziânia	SP	166.576
1506104	Primavera	PA	258.6
1506112	Quatipuru	PA	302.939
1506138	Redenção	PA	3823.809
1506161	Rio Maria	PA	4114.627
1506187	Rondon do Pará	PA	8246.394
1506195	Rurópolis	PA	7021.321
1506203	Salinópolis	PA	226.12
1506906	Santarém Novo	PA	229.51
2406304	Lagoa de Pedras	RN	117.971
2406403	Lagoa de Velhos	RN	111.607
1506302	Salvaterra	PA	918.563
1507300	São Félix do Xingu	PA	84212.903
1507409	São Francisco do Pará	PA	479.441
1507458	São Geraldo do Araguaia	PA	3168.384
2101731	Belágua	MA	569.606
3527801	Lupércio	SP	155.171
3527900	Lutécia	SP	475.226
1506351	Santa Bárbara do Pará	PA	278.154
1508100	Tucuruí	PA	2084.289
1508126	Ulianópolis	PA	5088.468
1508159	Uruará	PA	10791.406
2103208	Chapadinha	MA	3247.385
2103257	Cidelândia	MA	1462.809
2103307	Codó	MA	4361.606
2110401	São Benedito do Rio Preto	MA	931.485
2110500	São Bento	MA	456.997
3528007	Macatuba	SP	224.514
1506401	Santa Cruz do Arari	PA	1076.652
1506500	Santa Izabel do Pará	PA	717.662
1507003	Santo Antônio do Tauá	PA	537.618
1507102	São Caetano de Odivelas	PA	464.166
1507151	São Domingos do Araguaia	PA	1392.464
1507201	São Domingos do Capim	PA	1686.765
1507466	São João da Ponta	PA	195.918
1507474	São João de Pirabas	PA	668.434
1700400	Almas	TO	4007.152
1700707	Alvorada	TO	1207.201
1701002	Ananás	TO	1581.058
1701051	Angico	TO	447.549
1701101	Aparecida do Rio Negro	TO	1159.034
1701309	Aragominas	TO	1168.213
1701903	Araguacema	TO	2774.505
1702000	Araguaçu	TO	5155.223
1702109	Araguaína	TO	4004.646
1702158	Araguanã	TO	834.834
1702208	Araguatins	TO	2633.278
1702307	Arapoema	TO	1558.138
1702406	Arraias	TO	5803.085
1702554	Augustinópolis	TO	388.81
1702703	Aurora do Tocantins	TO	696.194
1702901	Axixá do Tocantins	TO	153.539
1703008	Babaçulândia	TO	1790.297
1703057	Bandeirantes do Tocantins	TO	1540.541
1703073	Barra do Ouro	TO	1105.84
1703107	Barrolândia	TO	697.759
1703206	Bernardo Sayão	TO	924.045
1703305	Bom Jesus do Tocantins	TO	1326.947
1703602	Brasilândia do Tocantins	TO	645.908
1703701	Brejinho de Nazaré	TO	1722.59
1703800	Buriti do Tocantins	TO	252.73
1703826	Cachoeirinha	TO	351.535
1703842	Campos Lindos	TO	3234.445
1703867	Cariri do Tocantins	TO	1126.291
1703883	Carmolândia	TO	339.366
1703891	Carrasco Bonito	TO	190.352
1703909	Caseara	TO	1680.014
1704105	Centenário	TO	1953.134
1704600	Chapada de Areia	TO	658.564
1705102	Chapada da Natividade	TO	1640.833
1507508	São João do Araguaia	PA	1279.889
1507607	São Miguel do Guamá	PA	1094.564
1705508	Colinas do Tocantins	TO	842.488
1705557	Combinado	TO	208.791
1705607	Conceição do Tocantins	TO	2530.647
1706001	Couto Magalhães	TO	1584.196
1706100	Cristalândia	TO	1850.75
1706258	Crixás do Tocantins	TO	983.766
1706506	Darcinópolis	TO	1641.77
1707009	Dianópolis	TO	3318.094
1707108	Divinópolis do Tocantins	TO	2358.282
1707207	Dois Irmãos do Tocantins	TO	3747.645
1707306	Dueré	TO	3420.657
1707405	Esperantina	TO	506.175
1707553	Fátima	TO	380.373
1707652	Figueirópolis	TO	1935.709
1707702	Filadélfia	TO	1991.258
1708205	Formoso do Araguaia	TO	13431.861
1708254	Tabocão	TO	624.463
1708304	Goianorte	TO	1797.229
1709005	Goiatins	TO	6414.846
1709302	Guaraí	TO	2106.753
1709500	Gurupi	TO	1844.164
1709807	Ipueiras	TO	821.152
1710508	Itacajá	TO	3047.204
1710706	Itaguatins	TO	730.163
1710904	Itapiratins	TO	1246.349
1711100	Itaporã do Tocantins	TO	969.794
1711506	Jaú do Tocantins	TO	2167.201
1711803	Juarina	TO	483.452
1711902	Lagoa da Confusão	TO	10563.181
1711951	Lagoa do Tocantins	TO	917.632
1712009	Lajeado	TO	318.292
1712157	Lavandeira	TO	468.006
1712405	Lizarda	TO	5716.641
1712454	Luzinópolis	TO	281.543
1712504	Marianópolis do Tocantins	TO	2089.575
1712702	Mateiros	TO	9589.273
1507706	São Sebastião da Boa Vista	PA	1632.251
1712801	Maurilândia do Tocantins	TO	736.303
1713205	Miracema do Tocantins	TO	2663.745
1507755	Sapucaia	PA	1298.19
1507805	Senador José Porfírio	PA	14419.916
1507904	Soure	PA	2857.349
1507953	Tailândia	PA	4430.477
1507961	Terra Alta	PA	204.97
1713304	Miranorte	TO	1033.301
1713601	Monte do Carmo	TO	3601.205
1713700	Monte Santo do Tocantins	TO	1072.92
1713809	Palmeiras do Tocantins	TO	743.407
1713957	Muricilândia	TO	1194.368
1714203	Natividade	TO	3241.672
1714302	Nazaré	TO	395.997
1714880	Nova Olinda	TO	1567.834
1715002	Nova Rosalândia	TO	514.791
1715101	Novo Acordo	TO	2678.262
1715150	Novo Alegre	TO	200.412
1715259	Novo Jardim	TO	1213.893
1715507	Oliveira de Fátima	TO	209.292
1715705	Palmeirante	TO	2638.465
1715754	Palmeirópolis	TO	1708.981
1716109	Paraíso do Tocantins	TO	1292.267
1716208	Paranã	TO	11217.373
1716307	Pau D'Arco	TO	1375.551
1716505	Pedro Afonso	TO	2019.556
1716604	Peixe	TO	5303.612
1716653	Pequizeiro	TO	1206.118
1716703	Colméia	TO	1161.03
1717008	Pindorama do Tocantins	TO	1560.551
1717206	Piraquê	TO	1363.412
1717503	Pium	TO	10003.549
1717800	Ponte Alta do Bom Jesus	TO	1718.791
1717909	Ponte Alta do Tocantins	TO	6542.838
1507979	Terra Santa	PA	1895.883
1508001	Tomé-Açu	PA	5145.361
1508035	Tracuateua	PA	868.025
1508050	Trairão	PA	11991.085
1508084	Tucumã	PA	2512.594
1508209	Vigia	PA	401.589
1508308	Viseu	PA	4972.897
1508357	Vitória do Xingu	PA	3089.537
1718006	Porto Alegre do Tocantins	TO	506.717
1718204	Porto Nacional	TO	4434.68
1718303	Praia Norte	TO	300.999
1718402	Presidente Kennedy	TO	771.716
1718451	Pugmil	TO	401.174
1718501	Recursolândia	TO	2215.669
1718550	Riachinho	TO	512.156
1718659	Rio da Conceição	TO	845.823
1718709	Rio dos Bois	TO	847.255
1718758	Rio Sono	TO	6346.279
1718808	Sampaio	TO	222.435
1718840	Sandolândia	TO	3535.135
1718865	Santa Fé do Araguaia	TO	1671.239
1718881	Santa Maria do Tocantins	TO	1412.318
1718899	Santa Rita do Tocantins	TO	3281.219
1718907	Santa Rosa do Tocantins	TO	1804.687
1719004	Santa Tereza do Tocantins	TO	539.511
1720002	Santa Terezinha do Tocantins	TO	274.104
1720101	São Bento do Tocantins	TO	1099.58
1720150	São Félix do Tocantins	TO	1913.11
1720200	São Miguel do Tocantins	TO	406.957
1720259	São Salvador do Tocantins	TO	1424.753
1720309	São Sebastião do Tocantins	TO	289.597
1720499	São Valério	TO	2520.465
1720655	Silvanópolis	TO	1258.771
1720804	Sítio Novo do Tocantins	TO	307.095
1720853	Sucupira	TO	1018.222
1720903	Taguatinga	TO	2341.919
1720937	Taipas do Tocantins	TO	1105.303
1720978	Talismã	TO	2155.503
1721000	Palmas	TO	2227.329
1721109	Tocantínia	TO	2609.775
1721208	Tocantinópolis	TO	1083.6
1721257	Tupirama	TO	706.883
1721307	Tupiratins	TO	889.126
1722081	Wanderlândia	TO	1365.431
1722107	Xambioá	TO	1190.489
2100055	Açailândia	MA	5805.159
3528106	Macaubal	SP	248.087
3528205	Macedônia	SP	327.567
3528304	Magda	SP	312.282
3528403	Mairinque	SP	210.149
3528502	Mairiporã	SP	320.697
3528601	Manduri	SP	229.046
3528700	Marabá Paulista	SP	919.519
3528809	Maracaí	SP	533.498
4218905	Urubici	SC	1021.371
1508407	Xinguara	PA	3779.348
1600055	Serra do Navio	AP	7713.046
1600105	Amapá	AP	8454.847
1600154	Pedra Branca do Amapari	AP	9622.29
1600204	Calçoene	AP	14117.297
1600212	Cutias	AP	2179.114
1600238	Ferreira Gomes	AP	4973.855
1600253	Itaubal	AP	1622.867
1600279	Laranjal do Jari	AP	30782.998
1600303	Macapá	AP	6563.849
1600402	Mazagão	AP	13294.778
1600501	Oiapoque	AP	23034.392
1600535	Porto Grande	AP	4428.013
1600550	Pracuúba	AP	4948.508
1600600	Santana	AP	1541.224
1600709	Tartarugalzinho	AP	6684.705
1600808	Vitória do Jari	AP	2508.979
1700251	Abreulândia	TO	1906.295
1700301	Aguiarnópolis	TO	236.792
1700350	Aliança do Tocantins	TO	1580.999
2100303	Aldeias Altas	MA	1942.121
2100402	Altamira do Maranhão	MA	524.374
2100436	Alto Alegre do Maranhão	MA	392.75
2100477	Alto Alegre do Pindaré	MA	1875.901
2100501	Alto Parnaíba	MA	11127.384
3530805	Mogi Mirim	SP	497.708
2101103	Axixá	MA	160.462
2101202	Bacabal	MA	1656.736
3531100	Mongaguá	SP	142.755
3531209	Monte Alegre do Sul	SP	110.308
3531308	Monte Alto	SP	346.95
3531407	Monte Aprazível	SP	495.559
3531506	Monte Azul Paulista	SP	263.462
3531605	Monte Castelo	SP	233.547
2101251	Bacabeira	MA	542.962
2101301	Bacuri	MA	850.491
2101350	Bacurituba	MA	413.651
2101400	Balsas	MA	13141.162
2101509	Barão de Grajaú	MA	2209.414
2101608	Barra do Corda	MA	5187.673
2101707	Barreirinhas	MA	3046.308
2406700	Lajes	RN	676.625
3531704	Monteiro Lobato	SP	332.742
3531803	Monte Mor	SP	240.566
3531902	Morro Agudo	SP	1388.127
3532009	Morungaba	SP	146.752
2101772	Bela Vista do Maranhão	MA	147.954
2101806	Benedito Leite	MA	1784.64
2104404	Gonçalves Dias	MA	883.588
3532058	Motuca	SP	228.7
3532108	Murutinga do Sul	SP	250.873
3532157	Nantes	SP	286.647
3532207	Narandiba	SP	357.325
3532306	Natividade da Serra	SP	833.372
2101905	Bequimão	MA	790.222
2101939	Bernardo do Mearim	MA	247.186
3532405	Nazaré Paulista	SP	326.254
3532504	Neves Paulista	SP	219.05
3532603	Nhandeara	SP	436.159
2101970	Boa Vista do Gurupi	MA	400.35
2102002	Bom Jardim	MA	6588.38
2102036	Bom Jesus das Selvas	MA	2676.98
2102077	Bom Lugar	MA	445.171
2102101	Brejo	MA	1073.258
2102150	Brejo de Areia	MA	986.036
2102200	Buriti	MA	1475.779
2102309	Buriti Bravo	MA	1582.552
2102325	Buriticupu	MA	2544.857
2102358	Buritirana	MA	820.968
2102374	Cachoeira Grande	MA	707.236
2102408	Cajapió	MA	545.244
2102507	Cajari	MA	662.066
2102556	Campestre do Maranhão	MA	613.529
2102606	Cândido Mendes	MA	1634.861
2102705	Cantanhede	MA	773.01
3532702	Nipoã	SP	137.609
3532801	Nova Aliança	SP	217.515
3532827	Nova Campina	SP	385.375
4218954	Urupema	SC	350.472
4219002	Urussanga	SC	254.954
4219101	Vargeão	SC	166.685
4219150	Vargem	SC	350.606
4219176	Vargem Bonita	SC	299.807
4219200	Vidal Ramos	SC	346.932
4219309	Videira	SC	384.127
4219358	Vitor Meireles	SC	370.414
4219408	Witmarsum	SC	153.776
4219507	Xanxerê	SC	377.426
4219606	Xavantina	SC	218.032
4219705	Xaxim	SC	293.628
4219853	Zortéa	SC	190.179
2102754	Capinzal do Norte	MA	590.267
2102804	Carolina	MA	6267.675
2102903	Carutapera	MA	1260.977
2103000	Caxias	MA	5201.927
2103109	Cedral	MA	285.211
2103125	Central do Maranhão	MA	319.538
2103158	Centro do Guilherme	MA	1167.848
2103174	Centro Novo do Maranhão	MA	8401.003
2103406	Coelho Neto	MA	977.079
2103505	Colinas	MA	1978.695
2103554	Conceição do Lago-Açu	MA	725.664
2103604	Coroatá	MA	2263.692
2103703	Cururupu	MA	1257.608
2103752	Davinópolis	MA	332.249
2105658	Junco do Maranhão	MA	568.499
4220000	Balneário Rincão	SC	63.42
4300001	Lagoa Mirim	RS	2884.34
2103802	Dom Pedro	MA	358.493
2103901	Duque Bacelar	MA	317.494
2104008	Esperantinópolis	MA	452.411
2104057	Estreito	MA	2720.266
2104073	Feira Nova do Maranhão	MA	1625.822
2104081	Fernando Falcão	MA	5086.589
2104099	Formosa da Serra Negra	MA	3690.61
2104107	Fortaleza dos Nogueiras	MA	1853.406
2104206	Fortuna	MA	834.83
2104305	Godofredo Viana	MA	720.129
2505501	Vista Serrana	PB	60.39
2104503	Governador Archer	MA	445.856
2104552	Governador Edison Lobão	MA	615.957
2106300	Magalhães de Almeida	MA	434.433
2106326	Maracaçumé	MA	635.758
2104602	Governador Eugênio Barros	MA	647.989
2104628	Governador Luiz Rocha	MA	401.587
2104651	Governador Newton Bello	MA	1144.146
2104677	Governador Nunes Freire	MA	1037.13
2106359	Marajá do Sena	MA	1402.593
2505600	Diamante	PB	271.791
2505709	Dona Inês	PB	173.648
4300002	Lagoa dos Patos	RS	10201.524
4300034	Aceguá	RS	1551.339
4300059	Água Santa	RS	291.503
4300109	Agudo	RS	534.624
4300208	Ajuricaba	RS	322.674
4300307	Alecrim	RS	316.394
4300406	Alegrete	RS	7800.428
4300455	Alegria	RS	172.794
4300471	Almirante Tamandaré do Sul	RS	265.042
4300505	Alpestre	RS	325.979
4300554	Alto Alegre	RS	115.335
5007935	Sonora	MS	4185.528
2104701	Graça Aranha	MA	271.445
2104800	Grajaú	MA	8861.717
2104909	Guimarães	MA	478.857
2105005	Humberto de Campos	MA	1714.625
2105104	Icatu	MA	1124.445
2107704	Paraibano	MA	530.517
2107803	Parnarama	MA	3245.525
2107902	Passagem Franca	MA	1358.327
5007950	Tacuru	MS	1784.207
5007976	Taquarussu	MS	1052.232
2105153	Igarapé do Meio	MA	368.685
2406809	Lajes Pintadas	RN	130.211
5008008	Terenos	MS	2845.723
2105203	Igarapé Grande	MA	346.218
2105302	Imperatriz	MA	1369.039
2105351	Itaipava do Grajaú	MA	1244.398
2105401	Itapecuru Mirim	MA	1480.641
2105427	Itinga do Maranhão	MA	3583.423
2105450	Jatobá	MA	591.616
2105476	Jenipapo dos Vieiras	MA	1962.362
2105500	João Lisboa	MA	1137.104
2105609	Joselândia	MA	703.081
5008305	Três Lagoas	MS	10217.071
2105708	Lago da Pedra	MA	1240.444
2105807	Lago do Junco	MA	328.525
2105906	Lago Verde	MA	631.455
2105922	Lagoa do Mato	MA	1512.985
4300570	Alto Feliz	RS	78.175
4300604	Alvorada	RS	71.7
4300638	Amaral Ferrador	RS	505.983
4300646	Ametista do Sul	RS	93.704
4300661	André da Rocha	RS	331.208
2105948	Lago dos Rodrigues	MA	220.776
2105963	Lagoa Grande do Maranhão	MA	744.199
2105989	Lajeado Novo	MA	1063.619
4300703	Anta Gorda	RS	242.1
4300802	Antônio Prado	RS	347.541
5104526	Ipiranga do Norte	MT	3422.016
5104542	Itanhangá	MT	2909.745
5104559	Itaúba	MT	4521.79
5104609	Itiquira	MT	8698.814
5104807	Jaciara	MT	2429.678
5104906	Jangada	MT	1114.302
5105002	Jauru	MT	1345.411
5105101	Juara	MT	22632.713
5105150	Juína	MT	26397.173
2106003	Lima Campos	MA	321.932
2106102	Loreto	MA	3597.231
2108454	Peritoró	MA	824.725
2108504	Pindaré-Mirim	MA	268.285
2108603	Pinheiro	MA	1512.969
4301107	Arroio dos Ratos	RS	425.791
4301206	Arroio do Tigre	RS	315.132
4301305	Arroio Grande	RS	2508.557
4301404	Arvorezinha	RS	269.31
4301503	Augusto Pestana	RS	348.231
4301552	Áurea	RS	156.727
4301602	Bagé	RS	4090.36
2106201	Luís Domingues	MA	472.296
2109601	Rosário	MA	647.998
2109700	Sambaíba	MA	2476.132
5105176	Juruena	MT	3207.837
5105200	Juscimeira	MT	2291.307
2106375	Maranhãozinho	MA	760.947
2106409	Mata Roma	MA	548.548
2106508	Matinha	MA	410.632
2106607	Matões	MA	2108.671
2106631	Matões do Norte	MA	794.454
2106672	Milagres do Maranhão	MA	634.818
2106706	Mirador	MA	8522.351
5105234	Lambari D'Oeste	MT	1810.547
5105259	Lucas do Rio Verde	MT	3674.596
5105309	Luciara	MT	4282.733
5105507	Vila Bela da Santíssima Trindade	MT	13484.71
5105580	Marcelândia	MT	12285.486
5105606	Matupá	MT	5228.272
5105622	Mirassol d'Oeste	MT	1085.486
5105903	Nobres	MT	3908.739
5106000	Nortelândia	MT	1336.754
2106755	Miranda do Norte	MA	341.107
2106805	Mirinzal	MA	686.942
2106904	Monção	MA	1245.548
2107001	Montes Altos	MA	1488.513
2107100	Morros	MA	1712.121
2107209	Nina Rodrigues	MA	570.938
2107258	Nova Colinas	MA	743.085
2110609	São Bernardo	MA	1005.824
2107308	Nova Iorque	MA	978.34
2107357	Nova Olinda do Maranhão	MA	2452.615
2110039	Santa Luzia do Paruá	MA	1010.483
2110104	Santa Quitéria do Maranhão	MA	1430.33
2110658	São Domingos do Azeitão	MA	961.249
2110708	São Domingos do Maranhão	MA	1151.978
2110807	São Félix de Balsas	MA	2032.599
5106109	Nossa Senhora do Livramento	MT	5537.413
5106158	Nova Bandeirantes	MT	9556.661
5106174	Nova Nazaré	MT	4034.539
5106182	Nova Lacerda	MT	4780.426
5106190	Nova Santa Helena	MT	2385.611
5106208	Nova Brasilândia	MT	3290.032
5106216	Nova Canaã do Norte	MT	5953.099
5106224	Nova Mutum	MT	9536.814
5106232	Nova Olímpia	MT	1327.266
5106240	Nova Ubiratã	MT	12460.736
5106257	Nova Xavantina	MT	5491.972
2107407	Olho d'Água das Cunhãs	MA	695.333
2107456	Olinda Nova do Maranhão	MA	199.879
2107506	Paço do Lumiar	MA	127.193
5106265	Novo Mundo	MT	5800.759
5106273	Novo Horizonte do Norte	MT	920.048
5106281	Novo São Joaquim	MT	5225.595
5106299	Paranaíta	MT	4814.149
5106307	Paranatinga	MT	24166.632
5106315	Novo Santo Antônio	MT	4394.78
5106372	Pedra Preta	MT	3841.672
5106422	Peixoto de Azevedo	MT	14433.775
5106455	Planalto da Serra	MT	2437.59
2107605	Palmeirândia	MA	532.161
2111748	Senador Alexandre Costa	MA	426.437
2111763	Senador La Rocque	MA	738.187
2111789	Serrano do Maranhão	MA	1165.318
2111805	Sítio Novo	MA	3114.683
2108009	Pastos Bons	MA	1635.181
2108058	Paulino Neves	MA	979.482
2108108	Paulo Ramos	MA	1168.609
2108207	Pedreiras	MA	262.066
2108256	Pedro do Rosário	MA	1753.867
2108306	Penalva	MA	800.916
2108405	Peri Mirim	MA	397.994
5106505	Poconé	MT	17156.759
5106653	Pontal do Araguaia	MT	2742.482
5106703	Ponte Branca	MT	701.138
5106752	Pontes e Lacerda	MT	8545.292
5106778	Porto Alegre do Norte	MT	3971.721
5106802	Porto dos Gaúchos	MT	6846.668
2108702	Pio XII	MA	545.14
2110237	Santana do Maranhão	MA	932.03
2110278	Santo Amaro do Maranhão	MA	1582.806
5106828	Porto Esperidião	MT	5835.278
5106851	Porto Estrela	MT	2045.467
2108801	Pirapemas	MA	688.761
5107008	Poxoréu	MT	6915.298
5107040	Primavera do Leste	MT	5470.383
5107065	Querência	MT	17799.989
5107107	São José dos Quatro Marcos	MT	1282.763
5107156	Reserva do Cabaçal	MT	1331.677
5107180	Ribeirão Cascalheira	MT	11354.555
5107198	Ribeirãozinho	MT	624.997
5107206	Rio Branco	MT	539.287
5107248	Santa Carmem	MT	3812.09
5107263	Santo Afonso	MT	1166.382
5107297	São José do Povo	MT	489.737
2108900	Poção de Pedras	MA	990.415
2109007	Porto Franco	MA	1420.51
2109056	Porto Rico do Maranhão	MA	244.979
2109106	Presidente Dutra	MA	771.574
2109205	Presidente Juscelino	MA	355.568
2109239	Presidente Médici	MA	437.687
2109270	Presidente Sarney	MA	726.172
2109304	Presidente Vargas	MA	460.004
2109403	Primeira Cruz	MA	1337.161
2109452	Raposa	MA	79.213
2109502	Riachão	MA	6402.83
2109551	Ribamar Fiquene	MA	733.458
2109759	Santa Filomena do Maranhão	MA	623.213
2109809	Santa Helena	MA	2191.168
2109908	Santa Inês	MA	786.689
2110005	Santa Luzia	MA	4837.169
5107305	São José do Rio Claro	MT	4525.304
5107354	São José do Xingu	MT	7465.563
2110203	Santa Rita	MA	756.797
2111904	Sucupira do Norte	MA	1074.435
2111953	Sucupira do Riachão	MA	862.226
2112001	Tasso Fragoso	MA	4369.159
5107404	São Pedro da Cipa	MT	344.33
2110302	Santo Antônio dos Lopes	MA	770.923
2112274	Tufilândia	MA	270.934
2112308	Tuntum	MA	3369.121
2112407	Turiaçu	MA	2622.281
2112456	Turilândia	MA	1507.622
2112506	Tutóia	MA	1566.08
2112605	Urbano Santos	MA	1707.621
2112704	Vargem Grande	MA	1958.702
2112803	Viana	MA	1166.745
2112852	Vila Nova dos Martírios	MA	1190.008
2112902	Vitória do Mearim	MA	716.719
2113009	Vitorino Freire	MA	1193.385
2114007	Zé Doca	MA	2140.109
2200053	Acauã	PI	1280.838
5107578	Rondolândia	MT	12658.341
5107602	Rondonópolis	MT	4824.02
5107701	Rosário Oeste	MT	7339.443
5107743	Santa Cruz do Xingu	MT	5623.39
5107750	Salto do Céu	MT	1753.378
5107768	Santa Rita do Trivelato	MT	4747.042
5107776	Santa Terezinha	MT	6466.223
5107792	Santo Antônio do Leste	MT	3403.593
5107800	Santo Antônio de Leverger	MT	9469.139
5107859	São Félix do Araguaia	MT	16682.473
5107875	Sapezal	MT	13614.552
5107883	Serra Nova Dourada	MT	1490.793
5107909	Sinop	MT	3990.87
5107925	Sorriso	MT	9293.629
2110856	São Francisco do Brejão	MA	745.357
2110906	São Francisco do Maranhão	MA	2284.217
2111003	São João Batista	MA	649.956
2111029	São João do Carú	MA	910.065
2111052	São João do Paraíso	MA	2052.328
5107941	Tabaporã	MT	8439.05
5107958	Tangará da Serra	MT	11636.825
5108006	Tapurah	MT	4492.539
5108055	Terra Nova do Norte	MT	2399.736
5108105	Tesouro	MT	4244.073
5108204	Torixoréu	MT	2398.383
5108303	União do Sul	MT	4590.628
5108352	Vale de São Domingos	MT	1901.545
5108402	Várzea Grande	MT	724.279
5108501	Vera	MT	3058.364
5108600	Vila Rica	MT	7436.383
5108808	Nova Guarita	MT	1121.928
2111078	São João do Soter	MA	1438.067
2111102	São João dos Patos	MA	1483.255
2111201	São José de Ribamar	MA	180.363
2111250	São José dos Basílios	MA	353.72
2111300	São Luís	MA	583.063
2111409	São Luís Gonzaga do Maranhão	MA	909.164
2111508	São Mateus do Maranhão	MA	800.045
2111532	São Pedro da Água Branca	MA	720.461
2111573	São Pedro dos Crentes	MA	979.915
2111607	São Raimundo das Mangabeiras	MA	3524.501
2111631	São Raimundo do Doca Bezerra	MA	419.55
2111672	São Roberto	MA	226.811
2111706	São Vicente Ferrer	MA	393.928
2200277	Alegrete do Piauí	PI	243.732
2200301	Alto Longá	PI	1743.331
5108857	Nova Marilândia	MT	1905.744
5108907	Nova Maringá	MT	11553.479
5108956	Nova Monte Verde	MT	5139.307
5200050	Abadia de Goiás	GO	143.357
2111722	Satubinha	MA	441.811
5200100	Abadiânia	GO	1044.555
5200134	Acreúna	GO	1566.742
5200159	Adelândia	GO	115.385
5200175	Água Fria de Goiás	GO	2023.636
2112100	Timbiras	MA	1486.584
2112209	Timon	MA	1763.22
2112233	Trizidela do Vale	MA	291.61
2200103	Agricolândia	PI	112.392
2200202	Água Branca	PI	96.843
2200251	Alagoinha do Piauí	PI	535.89
5200209	Água Limpa	GO	458.836
5200258	Águas Lindas de Goiás	GO	191.817
5200308	Alexânia	GO	846.876
2200400	Altos	PI	957.232
2406908	Lucrécia	RN	30.931
5200506	Aloândia	GO	102.094
5200555	Alto Horizonte	GO	500.342
5200605	Alto Paraíso de Goiás	GO	2594.998
5200803	Alvorada do Norte	GO	1268.347
2200459	Alvorada do Gurguéia	PI	2131.506
2201408	Barro Duro	PI	159.436
2200509	Amarante	PI	1152.127
2201507	Batalha	PI	1589.01
2407005	Luís Gomes	RN	166.638
5200829	Amaralina	GO	1343.742
5200852	Americano do Brasil	GO	133.834
5200902	Amorinópolis	GO	406.93
2200608	Angical do Piauí	PI	222.008
2200707	Anísio de Abreu	PI	337.877
2200806	Antônio Almeida	PI	644.8
2200905	Aroazes	PI	821.212
2201770	Boa Hora	PI	336.954
5201108	Anápolis	GO	935.672
5201207	Anhanguera	GO	55.569
5201306	Anicuns	GO	976.038
5201405	Aparecida de Goiânia	GO	279.954
5201454	Aparecida do Rio Doce	GO	603.254
5201504	Aporé	GO	2899.237
2200954	Aroeiras do Itaim	PI	316.235
2202109	Campinas do Piauí	PI	783.842
5201603	Araçu	GO	149.776
5201702	Aragarças	GO	661.677
5201801	Aragoiânia	GO	218.125
5202155	Araguapaz	GO	2188.1
5202353	Arenópolis	GO	1075.535
5202502	Aruanã	GO	3054.773
5202601	Aurilândia	GO	565.514
5202809	Avelinópolis	GO	170.228
5203104	Baliza	GO	1780.173
5203203	Barro Alto	GO	1080.268
5203302	Bela Vista de Goiás	GO	1274.034
5203401	Bom Jardim de Goiás	GO	1901.137
5203500	Bom Jesus de Goiás	GO	1405.605
5203559	Bonfinópolis	GO	121.915
5203575	Bonópolis	GO	1635.319
2201002	Arraial	PI	682.727
2201051	Assunção do Piauí	PI	1690.703
2201101	Avelino Lopes	PI	1220.371
2201150	Baixa Grande do Ribeiro	PI	7808.915
2201176	Barra D'Alcântara	PI	263.943
2201200	Barras	PI	1722.507
2201309	Barreiras do Piauí	PI	2168.713
5203609	Brazabrantes	GO	125.326
5203807	Britânia	GO	1458.459
5203906	Buriti Alegre	GO	901.932
2201556	Bela Vista do Piauí	PI	499.092
2202117	Campo Alegre do Fidalgo	PI	657.796
2919926	Madre de Deus	BA	32.201
2919959	Maetinga	BA	614.834
2201572	Belém do Piauí	PI	243.234
2201606	Beneditinos	PI	937.098
2201705	Bertolínia	PI	1216.116
2201739	Betânia do Piauí	PI	579.576
2201804	Bocaina	PI	261.651
2201903	Bom Jesus	PI	5471.024
2201919	Bom Princípio do Piauí	PI	523.142
2201929	Bonfim do Piauí	PI	289.149
2413706	Sítio Novo	RN	213.456
2920007	Maiquinique	BA	588.297
2920106	Mairi	BA	906.68
2201945	Boqueirão do Piauí	PI	269.786
2201960	Brasileira	PI	880.836
2201988	Brejo do Piauí	PI	2267.327
2202000	Buriti dos Lopes	PI	690.54
2202026	Buriti dos Montes	PI	2437.326
2920205	Malhada	BA	1979.193
2920304	Malhada de Pedras	BA	550.55
2920403	Manoel Vitorino	BA	2201.764
2920452	Mansidão	BA	3129.588
2920502	Maracás	BA	2413.27
2920601	Maragogipe	BA	437.61
2920700	Maraú	BA	848.885
2920809	Marcionílio Souza	BA	1099.283
2920908	Mascote	BA	742.689
2921005	Mata de São João	BA	605.168
2921054	Matina	BA	773.278
2202059	Cabeceiras do Piauí	PI	608.747
2202075	Cajazeiras do Piauí	PI	514.106
2202083	Cajueiro da Praia	PI	271.165
2202091	Caldeirão Grande do Piauí	PI	467.083
2921104	Medeiros Neto	BA	1311.739
2921203	Miguel Calmon	BA	1599.672
2921302	Milagres	BA	420.358
2921401	Mirangaba	BA	1751.778
2921450	Mirante	BA	1172.86
2921500	Monte Santo	BA	3034.197
2921609	Morpará	BA	2093.872
2921708	Morro do Chapéu	BA	5744.969
2921807	Mortugaba	BA	528.214
2921906	Mucugê	BA	2462.153
2922003	Mucuri	BA	1787.626
5203939	Buriti de Goiás	GO	202.576
2202133	Campo Grande do Piauí	PI	311.682
2210375	São Luis do Piauí	PI	217.924
2210383	São Miguel da Baixa Grande	PI	444.528
2202174	Campo Largo do Piauí	PI	478.078
2202208	Campo Maior	PI	1680.861
2202251	Canavieira	PI	2165.277
2202802	Conceição do Canindé	PI	824.729
2202851	Coronel José Dias	PI	1926.103
2202307	Canto do Buriti	PI	4325.643
2202406	Capitão de Campos	PI	571.658
2202455	Capitão Gervásio Oliveira	PI	1132.995
2202901	Corrente	PI	3048.747
2210391	São Miguel do Fidalgo	PI	813.444
2202505	Caracol	PI	1610.959
2202539	Caraúbas do Piauí	PI	471.217
2203008	Cristalândia do Piauí	PI	1202.896
2203107	Cristino Castro	PI	1845.698
2203206	Curimatá	PI	2344.949
2203230	Currais	PI	3156.657
2210409	São Miguel do Tapuio	PI	4988.973
2922102	Mundo Novo	BA	1491.99
2922201	Muniz Ferreira	BA	104.54
2922250	Muquém do São Francisco	BA	3852.111
2922300	Muritiba	BA	86.311
2202554	Caridade do Piauí	PI	498.793
2202604	Castelo do Piauí	PI	2378.847
2202653	Caxingó	PI	491.093
2203255	Curralinhos	PI	345.811
2203271	Curral Novo do Piauí	PI	755.251
2922409	Mutuípe	BA	275.854
2922508	Nazaré	BA	278.629
2922607	Nilo Peçanha	BA	388.936
2922656	Nordestina	BA	465.407
2922706	Nova Canaã	BA	804.617
5203962	Buritinópolis	GO	246.075
5204003	Cabeceiras	GO	1126.434
5204102	Cachoeira Alta	GO	1657.226
5204201	Cachoeira de Goiás	GO	424.49
2202703	Cocal	PI	1294.133
2203305	Demerval Lobão	PI	216.807
2210508	São Pedro do Piauí	PI	518.288
2202711	Cocal de Telha	PI	310.291
2203859	Floresta do Piauí	PI	223.199
2210607	São Raimundo Nonato	PI	2415.287
2202729	Cocal dos Alves	PI	324.856
2204105	Francisco Ayres	PI	656.475
2202737	Coivaras	PI	484.46
2210623	Sebastião Barros	PI	893.488
2414100	Tenente Ananias	RN	223.671
2923902	Pau Brasil	BA	626.306
2924009	Paulo Afonso	BA	1544.388
2924058	Pé de Serra	BA	596.771
2924108	Pedrão	BA	158.488
2924207	Pedro Alexandre	BA	889.572
2924306	Piatã	BA	1825.857
2202752	Colônia do Gurguéia	PI	429.591
2924405	Pilão Arcado	BA	11597.923
2924504	Pindaí	BA	628.468
2924603	Pindobaçu	BA	495.845
2924652	Pintadas	BA	647.144
2924678	Piraí do Norte	BA	193.427
2924702	Piripá	BA	511.756
2924801	Piritiba	BA	980.328
2924900	Planaltino	BA	955.454
2925006	Planalto	BA	769
2925105	Poções	BA	937.855
2925204	Pojuca	BA	314.932
2925253	Ponto Novo	BA	530.144
2202778	Colônia do Piauí	PI	950.193
2204659	Ilha Grande	PI	129.696
2925303	Porto Seguro	BA	2285.734
2925402	Potiraguá	BA	1111.567
2203354	Dirceu Arcoverde	PI	1005.571
2203404	Dom Expedito Lopes	PI	218.808
2203420	Domingos Mourão	PI	848.705
2203453	Dom Inocêncio	PI	3871.824
2203503	Elesbão Veloso	PI	1383.976
2203602	Eliseu Martins	PI	1097.79
2203701	Esperantina	PI	908.748
2925501	Prado	BA	1692.1
5204250	Cachoeira Dourada	GO	528.281
5204300	Caçu	GO	2254.34
5204409	Caiapônia	GO	8627.961
5204508	Caldas Novas	GO	1608.523
5204557	Caldazinha	GO	251.72
5204607	Campestre de Goiás	GO	272.734
5204656	Campinaçu	GO	1978.386
2203750	Fartura do Piauí	PI	713.046
2203800	Flores do Piauí	PI	946.719
2204709	Inhuma	PI	978.222
2204808	Ipiranga do Piauí	PI	529.417
5204706	Campinorte	GO	1064.541
5204805	Campo Alegre de Goiás	GO	2450.111
5204854	Campo Limpo de Goiás	GO	156.113
5204904	Campos Belos	GO	735.126
2203909	Floriano	PI	3407.979
2204006	Francinópolis	PI	268.704
2204154	Francisco Macedo	PI	179.245
2204204	Francisco Santos	PI	492.191
2204303	Fronteiras	PI	777.179
2204352	Geminiano	PI	440.606
2204402	Gilbués	PI	3495.692
2925600	Presidente Dutra	BA	232.064
2925709	Presidente Jânio Quadros	BA	1208.549
2925758	Presidente Tancredo Neves	BA	441.82
2925808	Queimadas	BA	2011.06
2204501	Guadalupe	PI	1026.538
2204550	Guaribas	PI	3118.231
2204600	Hugo Napoleão	PI	224.573
2925907	Quijingue	BA	1380.798
2925931	Quixabeira	BA	366.387
2925956	Rafael Jambeiro	BA	1090.552
2926004	Remanso	BA	4573.505
5204953	Campos Verdes	GO	443.125
5205000	Carmo do Rio Verde	GO	419.821
5205059	Castelândia	GO	299.228
5205109	Catalão	GO	3826.37
5205208	Caturaí	GO	205.065
5205307	Cavalcante	GO	6948.78
5205406	Ceres	GO	213.07
5205455	Cezarina	GO	417.08
5205471	Chapadão do Céu	GO	2184.076
5205497	Cidade Ocidental	GO	389.984
5205513	Cocalzinho de Goiás	GO	1785.339
5205521	Colinas do Sul	GO	1707.519
2205003	Itainópolis	PI	827.62
2205102	Itaueira	PI	2554.179
2205151	Jacobina do Piauí	PI	1333.796
5205703	Córrego do Ouro	GO	458.077
5205802	Corumbá de Goiás	GO	1064.833
5205901	Corumbaíba	GO	1864.277
5206206	Cristalina	GO	6153.921
5206305	Cristianópolis	GO	221.624
5206404	Crixás	GO	4673.039
5206503	Cromínia	GO	364.918
5206602	Cumari	GO	568.365
5206701	Damianópolis	GO	417.625
5206800	Damolândia	GO	86.057
5206909	Davinópolis	GO	482.857
5207105	Diorama	GO	685.382
5207253	Doverlândia	GO	3227.558
5207352	Edealina	GO	598.218
2205201	Jaicós	PI	866.788
2926103	Retirolândia	BA	242.329
2205250	Jardim do Mulato	PI	510.226
2205276	Jatobá do Piauí	PI	650.393
2205524	Júlio Borges	PI	1283.916
2926202	Riachão das Neves	BA	5977.931
2926301	Riachão do Jacuípe	BA	1155.418
2926400	Riacho de Santana	BA	3183.911
2926509	Ribeira do Amparo	BA	644.229
2926608	Ribeira do Pombal	BA	1252.144
2205300	Jerumenha	PI	1865.94
2205532	Jurema	PI	1271.881
2926657	Ribeirão do Largo	BA	1363.7
2926707	Rio de Contas	BA	1115.252
2926806	Rio do Antônio	BA	777.903
2926905	Rio do Pires	BA	656.223
2927002	Rio Real	BA	739.775
2927101	Rodelas	BA	2207.159
2927200	Ruy Barbosa	BA	1991.772
5207402	Edéia	GO	1469.099
5207501	Estrela do Norte	GO	301.139
5207535	Faina	GO	1949.685
5207600	Fazenda Nova	GO	1279.107
5207808	Firminópolis	GO	422.34
2205359	João Costa	PI	1800.23
2205409	Joaquim Pires	PI	740.561
2205540	Lagoinha do Piauí	PI	67.649
2414308	Timbaúba dos Batistas	RN	135.456
2414407	Touros	RN	753.961
2928059	Santa Luzia	BA	824.473
2928109	Santa Maria da Vitória	BA	1984.91
2928208	Santana	BA	1909.353
2928307	Santanópolis	BA	222.686
2205458	Joca Marques	PI	169.005
2205508	José de Freitas	PI	1538.172
2205516	Juazeiro do Piauí	PI	935.404
2928406	Santa Rita de Cássia	BA	6030.491
2928505	Santa Terezinha	BA	719.257
2928604	Santo Amaro	BA	494.502
2205557	Lagoa Alegre	PI	394.205
2205565	Lagoa do Barro do Piauí	PI	1331.025
2205573	Lagoa de São Francisco	PI	155.86
2206001	Marcos Parente	PI	677.416
2414456	Triunfo Potiguar	RN	268.725
2928703	Santo Antônio de Jesus	BA	261.74
2928802	Santo Estêvão	BA	360.334
2928901	São Desidério	BA	15156.712
2928950	São Domingos	BA	289.963
2929008	São Félix	BA	103.226
2929057	São Félix do Coribe	BA	1751.671
2929107	São Felipe	BA	222.407
2929206	São Francisco do Conde	BA	269.715
2205581	Lagoa do Piauí	PI	427.841
2205599	Lagoa do Sítio	PI	805.018
2205607	Landri Sales	PI	1088.583
2205706	Luís Correia	PI	1074.132
2205805	Luzilândia	PI	705.599
2206704	Nazaré do Piauí	PI	1315.841
2206720	Nazária	PI	362.376
2205854	Madeiro	PI	178.842
2205904	Manoel Emídio	PI	1620.413
2206753	Nossa Senhora de Nazaré	PI	356.872
2206803	Nossa Senhora dos Remédios	PI	357.896
2206902	Novo Oriente do Piauí	PI	525.906
2206951	Novo Santo Antônio	PI	443.872
2207009	Oeiras	PI	2703.138
2403400	Equador	RN	264.985
2929255	São Gabriel	BA	1146.054
2929305	São Gonçalo dos Campos	BA	294.768
2205953	Marcolândia	PI	136.785
2403509	Espírito Santo	RN	135.838
2929354	São José da Vitória	BA	127.925
2929370	São José do Jacuípe	BA	362.365
2929404	São Miguel das Matas	BA	230.906
2206050	Massapê do Piauí	PI	530.169
2206100	Matias Olímpio	PI	226.785
2929503	São Sebastião do Passé	BA	536.678
2929602	Sapeaçu	BA	131.218
2929701	Sátiro Dias	BA	949.223
2929750	Saubara	BA	166.428
2929800	Saúde	BA	509.098
2929909	Seabra	BA	2402.17
2930006	Sebastião Laranjeiras	BA	1984.511
2930105	Senhor do Bonfim	BA	789.361
2930154	Serra do Ramalho	BA	2340.684
2930204	Sento Sé	BA	11980.172
2930303	Serra Dourada	BA	1592.245
2930402	Serra Preta	BA	595.297
2930501	Serrinha	BA	583.314
2930600	Serrolândia	BA	322.022
2930709	Simões Filho	BA	201.528
2930758	Sítio do Mato	BA	1627.806
2930766	Sítio do Quinto	BA	684.089
2930774	Sobradinho	BA	1355.972
2930808	Souto Soares	BA	1026.634
2930907	Tabocas do Brejo Velho	BA	1437.189
2206209	Miguel Alves	PI	1392.123
2207306	Paes Landim	PI	401.378
2931004	Tanhaçu	BA	1277.514
2931053	Tanque Novo	BA	729.516
2931103	Tanquinho	BA	243.839
2931202	Taperoá	BA	454.081
2931301	Tapiramutá	BA	714.691
2931350	Teixeira de Freitas	BA	1165.622
2206308	Miguel Leão	PI	93.412
2206357	Milton Brandão	PI	1309.128
2207355	Pajeú do Piauí	PI	986.961
2207405	Palmeira do Piauí	PI	2024.02
2931400	Teodoro Sampaio	BA	244.613
2931509	Teofilândia	BA	351.892
2931608	Teolândia	BA	289.782
2931707	Terra Nova	BA	193.241
2206407	Monsenhor Gil	PI	567.86
2206506	Monsenhor Hipólito	PI	401.568
2931806	Tremedal	BA	2010.316
2931905	Tucano	BA	2198.237
2932002	Uauá	BA	3060.116
2932101	Ubaíra	BA	659.08
2932200	Ubaitaba	BA	181.102
2932309	Ubatã	BA	177.643
2932408	Uibaí	BA	545.298
2206605	Monte Alegre do Piauí	PI	2417.382
2206654	Morro Cabeça no Tempo	PI	2207.658
2207850	Pavussu	PI	1090.697
2207900	Pedro II	PI	1544.413
2932457	Umburanas	BA	1775.633
2932507	Una	BA	1126.733
2932606	Urandi	BA	902.402
2932705	Uruçuca	BA	510.098
5207907	Flores de Goiás	GO	3695.106
5208004	Formosa	GO	5804.292
5208103	Formoso	GO	843.42
5208152	Gameleira de Goiás	GO	588.328
5208301	Divinópolis de Goiás	GO	828.874
5208400	Goianápolis	GO	166.642
5208509	Goiandira	GO	569.917
5208608	Goianésia	GO	1547.319
5208707	Goiânia	GO	729.296
5208806	Goianira	GO	213.772
5208905	Goiás	GO	3108.423
5209101	Goiatuba	GO	2479.591
5209150	Gouvelândia	GO	827.373
5209200	Guapó	GO	514.178
2206670	Morro do Chapéu do Piauí	PI	328.408
2206696	Murici dos Portelas	PI	475.72
3103702	Araponga	MG	303.793
3103751	Araporã	MG	294.354
3103801	Arapuá	MG	173.894
3103900	Araújos	MG	245.522
3104007	Araxá	MG	1164.062
3104106	Arceburgo	MG	162.875
3104205	Arcos	MG	509.873
3104304	Areado	MG	283.124
3104403	Argirita	MG	159.378
3104452	Aricanduva	MG	243.329
3104502	Arinos	MG	5279.419
3104601	Astolfo Dutra	MG	158.891
3104700	Ataléia	MG	1836.925
3104809	Augusto de Lima	MG	1254.832
3104908	Baependi	MG	750.554
3105004	Baldim	MG	556.266
3105103	Bambuí	MG	1455.819
3105202	Bandeira	MG	483.789
3105301	Bandeira do Sul	MG	47.266
3105400	Barão de Cocais	MG	340.14
3105509	Barão de Monte Alto	MG	198.313
3105608	Barbacena	MG	759.186
2207108	Olho D'Água do Piauí	PI	183.603
2207959	Nova Santa Rita	PI	909.734
3105707	Barra Longa	MG	383.628
3105905	Barroso	MG	82.07
3106002	Bela Vista de Minas	MG	109.143
3106101	Belmiro Braga	MG	393.086
3106200	Belo Horizonte	MG	331.354
3106309	Belo Oriente	MG	334.909
3106408	Belo Vale	MG	365.923
3106507	Berilo	MG	587.106
3106606	Bertópolis	MG	427.803
3106655	Berizal	MG	488.756
3106705	Betim	MG	344.062
2207207	Padre Marcos	PI	278.696
3106804	Bias Fortes	MG	283.535
3106903	Bicas	MG	140.082
3107000	Biquinhas	MG	458.948
3107109	Boa Esperança	MG	860.669
3107208	Bocaina de Minas	MG	503.77
3107307	Bocaiúva	MG	3206.757
3107406	Bom Despacho	MG	1213.546
3107505	Bom Jardim de Minas	MG	412.021
3107604	Bom Jesus da Penha	MG	208.349
3107703	Bom Jesus do Amparo	MG	195.611
3107802	Bom Jesus do Galho	MG	592.289
3107901	Bom Repouso	MG	229.845
3108008	Bom Sucesso	MG	705.046
3108107	Bonfim	MG	301.865
3108206	Bonfinópolis de Minas	MG	1850.487
3108255	Bonito de Minas	MG	3936.455
3108305	Borda da Mata	MG	301.108
2207504	Palmeirais	PI	1493.764
2208809	Regeneração	PI	1251.321
2208858	Riacho Frio	PI	2220.598
3108404	Botelhos	MG	334.089
3108503	Botumirim	MG	1568.884
3108552	Brasilândia de Minas	MG	2509.694
3108602	Brasília de Minas	MG	1399.484
3108701	Brás Pires	MG	223.351
3108800	Braúnas	MG	378.318
3108909	Brazópolis	MG	367.688
3109006	Brumadinho	MG	639.434
3109105	Bueno Brandão	MG	356.15
3109204	Buenópolis	MG	1599.881
3109253	Bugre	MG	161.491
3109303	Buritis	MG	5225.186
3109402	Buritizeiro	MG	7218.401
3109451	Cabeceira Grande	MG	1033.055
2207553	Paquetá	PI	432.572
2207603	Parnaguá	PI	3428.811
2207702	Parnaíba	PI	436.907
2207751	Passagem Franca do Piauí	PI	643.226
2209351	Santana do Piauí	PI	112.189
2209377	Santa Rosa do Piauí	PI	338.336
3109501	Cabo Verde	MG	368.206
3109600	Cachoeira da Prata	MG	61.381
3109709	Cachoeira de Minas	MG	304.243
3109808	Cachoeira Dourada	MG	203.07
3109907	Caetanópolis	MG	156.039
3110004	Caeté	MG	542.531
3110103	Caiana	MG	106.465
3110202	Cajuri	MG	83.038
3110301	Caldas	MG	711.414
3110400	Camacho	MG	223.001
2207777	Patos do Piauí	PI	801.403
2207793	Pau D'Arco do Piauí	PI	430.023
2207801	Paulistana	PI	1941.111
3110509	Camanducaia	MG	528.688
3110608	Cambuí	MG	244.567
3110707	Cambuquira	MG	246.38
3110806	Campanário	MG	442.398
3110905	Campanha	MG	335.587
2207934	Pedro Laurentino	PI	870.614
3111002	Campestre	MG	577.843
3111101	Campina Verde	MG	3650.749
3111150	Campo Azul	MG	505.914
3111200	Campo Belo	MG	528.225
3111309	Campo do Meio	MG	275.426
3111408	Campo Florido	MG	1264.245
3111507	Campos Altos	MG	710.645
3111606	Campos Gerais	MG	769.504
3111705	Canaã	MG	174.9
3111804	Canápolis	MG	843.599
3111903	Cana Verde	MG	212.721
3112000	Candeias	MG	720.512
3112059	Cantagalo	MG	141.855
3112109	Caparaó	MG	130.694
3112208	Capela Nova	MG	111.073
3112307	Capelinha	MG	965.292
3112406	Capetinga	MG	297.937
3112505	Capim Branco	MG	95.333
2208007	Picos	PI	577.284
2208106	Pimenteiras	PI	4562.58
2208205	Pio IX	PI	1948.142
2209401	Santo Antônio de Lisboa	PI	385.286
3112604	Capinópolis	MG	620.716
3112653	Capitão Andrade	MG	279.088
3112703	Capitão Enéas	MG	971.576
3112802	Capitólio	MG	521.802
2208304	Piracuruca	PI	2368.935
2208403	Piripiri	PI	1407.192
2208502	Porto	PI	253.113
2208551	Porto Alegre do Piauí	PI	1168.044
3112901	Caputira	MG	187.704
3113008	Caraí	MG	1242.345
3113107	Caranaíba	MG	159.95
2208601	Prata do Piauí	PI	196.787
2209450	Santo Antônio dos Milagres	PI	33.64
3113206	Carandaí	MG	487.28
3113305	Carangola	MG	353.404
3113404	Caratinga	MG	1258.479
3113503	Carbonita	MG	1456.095
3113602	Careaçu	MG	181.009
3113701	Carlos Chagas	MG	3202.984
3113800	Carmésia	MG	259.103
3113909	Carmo da Cachoeira	MG	506.333
3114006	Carmo da Mata	MG	357.178
3114105	Carmo de Minas	MG	322.285
3114204	Carmo do Cajuru	MG	455.808
3114303	Carmo do Paranaíba	MG	1307.862
3114402	Carmo do Rio Claro	MG	1065.685
3114501	Carmópolis de Minas	MG	400.01
2208650	Queimada Nova	PI	1283.369
2208700	Redenção do Gurguéia	PI	2470.531
3114550	Carneirinho	MG	2063.462
3114600	Carrancas	MG	727.894
3114709	Carvalhópolis	MG	81.101
3114808	Carvalhos	MG	282.254
3114907	Casa Grande	MG	157.727
3115003	Cascalho Rico	MG	367.308
3115102	Cássia	MG	665.802
3115201	Conceição da Barra de Minas	MG	273.014
3115300	Cataguases	MG	491.767
3115359	Catas Altas	MG	240.042
3115409	Catas Altas da Noruega	MG	141.622
3115458	Catuji	MG	419.38
3115474	Catuti	MG	287.812
3115508	Caxambu	MG	100.483
2208874	Ribeira do Piauí	PI	1012.479
2208908	Ribeiro Gonçalves	PI	3987.147
2209005	Rio Grande do Piauí	PI	635.953
3115607	Cedro do Abaeté	MG	283.211
3115706	Central de Minas	MG	204.328
3115805	Centralina	MG	322.385
3115904	Chácara	MG	152.807
3116001	Chalé	MG	212.674
3116100	Chapada do Norte	MG	830.833
3116159	Chapada Gaúcha	MG	3255.189
3116209	Chiador	MG	252.852
3116308	Cipotânea	MG	153.479
3116407	Claraval	MG	227.627
3116506	Claro dos Poções	MG	720.424
3116605	Cláudio	MG	630.706
3116704	Coimbra	MG	106.875
3116803	Coluna	MG	348.492
3116902	Comendador Gomes	MG	1041.047
3117009	Comercinho	MG	654.961
3117108	Conceição da Aparecida	MG	352.521
3117207	Conceição das Pedras	MG	102.206
3117306	Conceição das Alagoas	MG	1340.25
3117405	Conceição de Ipanema	MG	253.935
2209104	Santa Cruz do Piauí	PI	582.658
2209153	Santa Cruz dos Milagres	PI	978.547
2209203	Santa Filomena	PI	5293.693
3117504	Conceição do Mato Dentro	MG	1720.04
3117603	Conceição do Pará	MG	250.306
3117702	Conceição do Rio Verde	MG	369.681
3117801	Conceição dos Ouros	MG	180.236
3117836	Cônego Marinho	MG	1610.47
3117876	Confins	MG	42.355
3117900	Congonhal	MG	205.125
3118007	Congonhas	MG	304.067
3118106	Congonhas do Norte	MG	405.671
3118205	Conquista	MG	618.363
3118304	Conselheiro Lafaiete	MG	370.246
3118403	Conselheiro Pena	MG	1483.883
3118502	Consolação	MG	89.122
2209302	Santa Luz	PI	1185.398
3118601	Contagem	MG	194.746
3118700	Coqueiral	MG	296.163
3118809	Coração de Jesus	MG	2225.216
3118908	Cordisburgo	MG	823.654
3119005	Cordislândia	MG	179.543
3119104	Corinto	MG	2525.397
3119203	Coroaci	MG	576.274
3119302	Coromandel	MG	3313.313
3119401	Coronel Fabriciano	MG	221.252
2209500	Santo Inácio do Piauí	PI	852.106
2209807	São Gonçalo do Piauí	PI	150.495
2209856	São João da Canabrava	PI	480.537
2209559	São Braz do Piauí	PI	656.042
2209609	São Félix do Piauí	PI	627.033
2209658	São Francisco de Assis do Piauí	PI	1072.311
2209708	São Francisco do Piauí	PI	1341.451
2209757	São Gonçalo do Gurguéia	PI	1385.255
2209872	São João da Fronteira	PI	817.111
2209906	São João da Serra	PI	994.224
3119500	Coronel Murta	MG	815.413
3119609	Coronel Pacheco	MG	131.511
3119708	Coronel Xavier Chaves	MG	140.954
3119807	Córrego Danta	MG	657.425
3119906	Córrego do Bom Jesus	MG	123.651
3119955	Córrego Fundo	MG	101.112
3120003	Córrego Novo	MG	205.385
3120102	Couto de Magalhães de Minas	MG	485.654
3120151	Crisólita	MG	966.202
3120201	Cristais	MG	628.434
3120300	Cristália	MG	840.702
2209955	São João da Varjota	PI	394.456
2209971	São João do Arraial	PI	213.377
2210102	São José do Peixe	PI	1287.174
3120409	Cristiano Otoni	MG	132.872
3120508	Cristina	MG	311.33
3120607	Crucilândia	MG	167.164
2210003	São João do Piauí	PI	1527.497
2210052	São José do Divino	PI	319.367
2210201	São José do Piauí	PI	373.347
3120706	Cruzeiro da Fortaleza	MG	187.446
3120805	Cruzília	MG	522.419
3120839	Cuparaque	MG	226.75
2210631	Sebastião Leal	PI	3148.857
2210656	Sigefredo Pacheco	PI	1031.101
2210706	Simões	PI	1076.055
2210938	Sussuapara	PI	205.194
3120870	Curral de Dentro	MG	570.95
3120904	Curvelo	MG	3296.2
3121001	Datas	MG	310.099
3121100	Delfim Moreira	MG	408.473
3121209	Delfinópolis	MG	1378.423
3121258	Delta	MG	102.784
2210805	Simplício Mendes	PI	1360.028
2210904	Socorro do Piauí	PI	761.854
2210953	Tamboril do Piauí	PI	1587.296
2211605	Vila Nova do Piauí	PI	221.627
2210979	Tanque do Piauí	PI	398.007
2211001	Teresina	PI	1391.293
2211100	União	PI	1170.742
2211209	Uruçuí	PI	8413.016
2211308	Valença do Piauí	PI	1333.722
2211357	Várzea Branca	PI	450.429
2403756	Fernando Pedroza	RN	322.628
3121308	Descoberto	MG	213.168
3121407	Desterro de Entre Rios	MG	377.165
2211407	Várzea Grande	PI	236.453
2211506	Vera Mendes	PI	341.974
3121506	Desterro do Melo	MG	142.279
3121605	Diamantina	MG	3891.659
3121704	Diogo de Vasconcelos	MG	165.091
3121803	Dionísio	MG	339.375
3121902	Divinésia	MG	116.97
3122009	Divino	MG	337.776
3122108	Divino das Laranjeiras	MG	342.249
3122207	Divinolândia de Minas	MG	133.12
3122306	Divinópolis	MG	708.115
2211704	Wall Ferraz	PI	270.427
2404309	Governador Dix-Sept Rosado	RN	1129.55
3122355	Divisa Alegre	MG	117.802
3122405	Divisa Nova	MG	216.955
3122454	Divisópolis	MG	572.926
2300101	Abaiara	CE	180.833
2404606	Ielmo Marinho	RN	312.028
3122470	Dom Bosco	MG	817.383
3122504	Dom Cavati	MG	59.52
3122603	Dom Joaquim	MG	398.793
3122702	Dom Silvério	MG	194.972
3122801	Dom Viçoso	MG	113.921
3122900	Dona Euzébia	MG	70.231
3123007	Dores de Campos	MG	124.842
3123106	Dores de Guanhães	MG	382.124
2300150	Acarape	CE	130.002
2300200	Acaraú	CE	842.471
2300309	Acopiara	CE	2254.279
2300408	Aiuaba	CE	2438.563
2300507	Alcântaras	CE	135.76
3123205	Dores do Indaiá	MG	1111.202
3123304	Dores do Turvo	MG	231.169
3123403	Doresópolis	MG	152.912
2300606	Altaneira	CE	72.675
2300705	Alto Santo	CE	1147.208
2300754	Amontada	CE	1175.044
2300804	Antonina do Norte	CE	259.706
2300903	Apuiarés	CE	543.98
2301000	Aquiraz	CE	480.236
2301109	Aracati	CE	1227.197
2301208	Aracoiaba	CE	643.988
2301257	Ararendá	CE	342.301
2306207	Itaiçaba	CE	213.604
3123502	Douradoquara	MG	312.878
3123528	Durandé	MG	217.461
3123601	Elói Mendes	MG	499.537
3123700	Engenheiro Caldas	MG	187.058
3123809	Engenheiro Navarro	MG	608.306
3123858	Entre Folhas	MG	85.39
2301307	Araripe	CE	1097.339
2301406	Aratuba	CE	119.758
2301505	Arneiroz	CE	1068.437
2301604	Assaré	CE	1155.124
2301703	Aurora	CE	885.87
2301802	Baixio	CE	145.556
2301851	Banabuiú	CE	1080.986
2307007	Jaguaruana	CE	854.362
3123908	Entre Rios de Minas	MG	456.796
3124005	Ervália	MG	357.489
3124104	Esmeraldas	MG	909.727
3124203	Espera Feliz	MG	317.638
3124302	Espinosa	MG	1868.97
3124401	Espírito Santo do Dourado	MG	263.879
3124500	Estiva	MG	243.872
3124609	Estrela Dalva	MG	131.365
3124708	Estrela do Indaiá	MG	635.981
3124807	Estrela do Sul	MG	822.454
3124906	Eugenópolis	MG	309.395
3125002	Ewbank da Câmara	MG	103.834
3125101	Extrema	MG	244.575
3125200	Fama	MG	86.024
3125309	Faria Lemos	MG	165.224
3125408	Felício dos Santos	MG	357.622
2301901	Barbalha	CE	608.158
2301950	Barreira	CE	260.003
3125507	São Gonçalo do Rio Preto	MG	314.458
3125606	Felisburgo	MG	596.215
3125705	Felixlândia	MG	1554.627
3125804	Fernandes Tourinho	MG	151.875
3125903	Ferros	MG	1088.791
3125952	Fervedouro	MG	357.683
3126000	Florestal	MG	194.242
3126109	Formiga	MG	1501.915
3126208	Formoso	MG	3686.004
3126307	Fortaleza de Minas	MG	218.792
2302008	Barro	CE	711.346
2302057	Barroquinha	CE	385.583
2302107	Baturité	CE	314.075
2302206	Beberibe	CE	1596.751
2302305	Bela Cruz	CE	842.106
2302404	Boa Viagem	CE	2835.037
2302503	Brejo Santo	CE	654.658
2302602	Camocim	CE	1120.452
2302701	Campos Sales	CE	1082.582
2302800	Canindé	CE	3032.39
2302909	Capistrano	CE	226.549
2303006	Caridade	CE	926.271
2303105	Cariré	CE	755.597
2303204	Caririaçu	CE	634.179
2303303	Cariús	CE	1036.417
3126406	Fortuna de Minas	MG	198.709
3126505	Francisco Badaró	MG	461.481
3126604	Francisco Dumont	MG	1576.128
2303402	Carnaubal	CE	363.22
2303501	Cascavel	CE	838.115
2303600	Catarina	CE	488.153
2303659	Catunda	CE	784.022
2303709	Caucaia	CE	1223.246
2303808	Cedro	CE	729.97
3126703	Francisco Sá	MG	2747.295
3126752	Franciscópolis	MG	717.087
2303907	Chaval	CE	237.248
2303931	Choró	CE	815.268
3126802	Frei Gaspar	MG	626.672
3126901	Frei Inocêncio	MG	469.557
3126950	Frei Lagonegro	MG	167.474
3127008	Fronteira	MG	199.987
3127057	Fronteira dos Vales	MG	320.757
3127073	Fruta de Leite	MG	762.837
3127107	Frutal	MG	2426.965
2303956	Chorozinho	CE	296.431
2304004	Coreaú	CE	750.332
2304103	Crateús	CE	2981.459
2304202	Crato	CE	1138.15
2304236	Croatá	CE	696.348
2304251	Cruz	CE	335.921
2304269	Deputado Irapuan Pinheiro	CE	471.134
2304277	Ereré	CE	362.906
2304285	Eusébio	CE	78.818
2304301	Farias Brito	CE	530.54
2304350	Forquilha	CE	568.778
2304400	Fortaleza	CE	312.353
2304459	Fortim	CE	285.024
2304509	Frecheirinha	CE	210.284
3127206	Funilândia	MG	199.797
3127305	Galiléia	MG	720.303
3127339	Gameleiras	MG	1733.203
3127354	Glaucilândia	MG	145.861
3127370	Goiabeira	MG	112.443
3127388	Goianá	MG	152.039
3127404	Gonçalves	MG	187.353
3127503	Gonzaga	MG	209.348
3127602	Gouveia	MG	866.601
3127701	Governador Valadares	MG	2342.376
3127800	Grão Mogol	MG	3885.294
3127909	Grupiara	MG	193.141
2304608	General Sampaio	CE	230.371
3128006	Guanhães	MG	1075.124
3128105	Guapé	MG	934.345
3128204	Guaraciaba	MG	348.596
3128253	Guaraciama	MG	390.263
3128303	Guaranésia	MG	294.828
2304657	Graça	CE	258.942
2304707	Granja	CE	2663.174
2404903	Itaú	RN	133.031
3128402	Guarani	MG	264.194
2304806	Granjeiro	CE	111.528
2304905	Groaíras	CE	155.681
2304954	Guaiúba	CE	256.053
2305001	Guaraciaba do Norte	CE	624.606
2307106	Jardim	CE	544.98
3128501	Guarará	MG	88.655
3128600	Guarda-Mor	MG	2068.808
3128709	Guaxupé	MG	286.398
3128808	Guidoval	MG	158.375
2305100	Guaramiranga	CE	90.817
2305209	Hidrolândia	CE	926.592
2307700	Maranguape	CE	583.505
2307809	Marco	CE	573.61
3128907	Guimarânia	MG	366.833
3129004	Guiricema	MG	293.578
3129103	Gurinhatã	MG	1849.137
3129202	Heliodora	MG	153.95
3129301	Iapu	MG	340.994
3129400	Ibertioga	MG	346.24
3129509	Ibiá	MG	2704.132
2305233	Horizonte	CE	160.557
2305266	Ibaretama	CE	879.255
2305308	Ibiapina	CE	414.092
2305332	Ibicuitinga	CE	423.856
2305357	Icapuí	CE	421.44
2305407	Icó	CE	1865.862
2305506	Iguatu	CE	992.208
2305605	Independência	CE	3222.381
2305654	Ipaporanga	CE	704.773
2305704	Ipaumirim	CE	276.508
2305803	Ipu	CE	626.049
2305902	Ipueiras	CE	1483.258
2306009	Iracema	CE	839.174
2306108	Irauçuba	CE	1466.412
2307908	Martinópole	CE	303.445
2308005	Massapê	CE	567.78
3129608	Ibiaí	MG	874.76
2306256	Itaitinga	CE	153.686
2306306	Itapajé	CE	432.188
2306405	Itapipoca	CE	1600.358
2306504	Itapiúna	CE	593.231
2306553	Itarema	CE	714.833
2306603	Itatira	CE	829.626
2306702	Jaguaretama	CE	1826.826
2306801	Jaguaribara	CE	622.963
2306900	Jaguaribe	CE	1877.062
2307205	Jati	CE	368.359
2309300	Nova Russas	CE	736.911
2309409	Novo Oriente	CE	947.44
2309458	Ocara	CE	763.075
2309508	Orós	CE	577.526
3129657	Ibiracatu	MG	353.257
3129707	Ibiraci	MG	562.095
3129806	Ibirité	MG	72.395
3129905	Ibitiúra de Minas	MG	68.316
3130002	Ibituruna	MG	153.106
3130051	Icaraí de Minas	MG	625.664
3130101	Igarapé	MG	110.942
3130200	Igaratinga	MG	218.343
3130309	Iguatama	MG	628.2
2307254	Jijoca de Jericoacoara	CE	209.029
2307304	Juazeiro do Norte	CE	258.788
2307403	Jucás	CE	940.336
2307502	Lavras da Mangabeira	CE	945.263
2307601	Limoeiro do Norte	CE	744.525
2307635	Madalena	CE	997.781
2307650	Maracanaú	CE	105.071
2308104	Mauriti	CE	1079.011
2308203	Meruoca	CE	151.651
2310258	Paraipaba	CE	289.231
2310308	Parambu	CE	2313.868
2310407	Paramoti	CE	539.238
2310506	Pedra Branca	CE	1302.081
2405009	Jaçanã	RN	54.561
3130408	Ijaci	MG	105.246
3130507	Ilicínea	MG	376.341
3130556	Imbé de Minas	MG	196.735
2308302	Milagres	CE	579.097
2308351	Milhã	CE	502.137
2308377	Miraíma	CE	708.678
2308401	Missão Velha	CE	613.317
2308500	Mombaça	CE	2115.748
2308609	Monsenhor Tabosa	CE	892.538
2308708	Morada Nova	CE	2763.971
2308807	Moraújo	CE	414.446
2308906	Morrinhos	CE	411.586
2309003	Mucambo	CE	192.19
2313104	Tabuleiro do Norte	CE	1047.637
2313203	Tamboril	CE	2014.543
2313252	Tarrafas	CE	412.719
2313302	Tauá	CE	4010.618
2313351	Tejuçuoca	CE	758.707
2313401	Tianguá	CE	909.853
2313500	Trairi	CE	928.725
2309102	Mulungu	CE	97.951
2309201	Nova Olinda	CE	282.584
2309607	Pacajus	CE	250.304
2309706	Pacatuba	CE	133.236
2309805	Pacoti	CE	112.433
2313559	Tururu	CE	201.27
2313609	Ubajara	CE	423.673
2402501	Carnaubais	RN	517.737
2402600	Ceará-Mirim	RN	724.838
3130606	Inconfidentes	MG	149.611
2309904	Pacujá	CE	88.355
2310001	Palhano	CE	436.98
2310100	Palmácia	CE	128.896
2310209	Paracuru	CE	304.734
2310605	Penaforte	CE	150.536
2310704	Pentecoste	CE	1379.836
2310803	Pereiro	CE	435.868
2310852	Pindoretama	CE	74.033
2310902	Piquet Carneiro	CE	589.601
2310951	Pires Ferreira	CE	244.464
2311009	Poranga	CE	1310.771
2311108	Porteiras	CE	224.86
3130655	Indaiabira	MG	1004.149
3130705	Indianópolis	MG	830.03
3130804	Ingaí	MG	305.591
3130903	Inhapim	MG	858.024
2311207	Potengi	CE	343.264
2311231	Potiretama	CE	409.137
2311264	Quiterianópolis	CE	1041.832
2311306	Quixadá	CE	2020.586
2313807	Uruburetama	CE	99.4
2313906	Uruoca	CE	697.683
2405108	Jandaíra	RN	442.754
3131000	Inhaúma	MG	244.996
2311355	Quixelô	CE	605.345
2311405	Quixeramobim	CE	3324.987
2311504	Quixeré	CE	613.099
2311603	Redenção	CE	247.989
2400307	Afonso Bezerra	RN	576.179
2400406	Água Nova	RN	50.684
3131109	Inimutaba	MG	527.06
3131158	Ipaba	MG	113.246
3131208	Ipanema	MG	456.641
2311702	Reriutaba	CE	372.949
2311801	Russas	CE	1611.091
2311900	Saboeiro	CE	1381.274
2311959	Salitre	CE	806.253
2312007	Santana do Acaraú	CE	972.573
2405504	Jardim de Angicos	RN	254.022
3131307	Ipatinga	MG	164.884
3131406	Ipiaçu	MG	466.02
3131505	Ipuiúna	MG	298.195
2312106	Santana do Cariri	CE	855.165
2312205	Santa Quitéria	CE	4262.293
2312304	São Benedito	CE	350.847
2312403	São Gonçalo do Amarante	CE	842.635
2402709	Cerro Corá	RN	393.573
3131604	Iraí de Minas	MG	356.264
3131703	Itabira	MG	1253.704
3131802	Itabirinha	MG	209.034
3131901	Itabirito	MG	544.027
2312502	São João do Jaguaribe	CE	279.451
2312601	São Luís do Curu	CE	122.865
2312700	Senador Pompeu	CE	956.882
2312809	Senador Sá	CE	424.642
2312908	Sobral	CE	2068.474
2313005	Solonópole	CE	1535.855
2313708	Umari	CE	263.183
2313757	Umirim	CE	315.648
3132008	Itacambira	MG	1788.445
3132107	Itacarambi	MG	1225.273
3132206	Itaguara	MG	410.468
3132305	Itaipé	MG	480.829
3132404	Itajubá	MG	294.835
3132503	Itamarandiba	MG	2735.573
3132602	Itamarati de Minas	MG	94.568
3132701	Itambacuri	MG	1419.209
3132800	Itambé do Mato Dentro	MG	380.34
2313955	Varjota	CE	179.239
2314003	Várzea Alegre	CE	829.976
3132909	Itamogi	MG	243.714
3133006	Itamonte	MG	431.792
3133105	Itanhandu	MG	143.363
3133204	Itanhomi	MG	488.843
3133303	Itaobim	MG	679.024
3133402	Itapagipe	MG	1802.438
2314102	Viçosa do Ceará	CE	1310.91
2400109	Acari	RN	608.466
2400208	Açu	RN	1303.442
3133501	Itapecerica	MG	1040.519
3133600	Itapeva	MG	177.347
3133709	Itatiaiuçu	MG	295.145
3133758	Itaú de Minas	MG	153.421
3133808	Itaúna	MG	495.769
3133907	Itaverava	MG	284.22
2400505	Alexandria	RN	381.205
2400604	Almino Afonso	RN	128.038
2400703	Alto do Rodrigues	RN	191.334
3134004	Itinga	MG	1649.622
3134103	Itueta	MG	452.676
2400802	Angicos	RN	741.582
2401305	Campo Grande	RN	890.89
3134202	Ituiutaba	MG	2598.046
3134301	Itumirim	MG	234.802
3134400	Iturama	MG	1404.663
3134509	Itutinga	MG	372.018
2400901	Antônio Martins	RN	244.897
2401453	Baraúna	RN	825.681
2402808	Coronel Ezequiel	RN	185.748
3134608	Jaboticatubas	MG	1114.972
3134707	Jacinto	MG	1393.609
3134806	Jacuí	MG	409.229
3134905	Jacutinga	MG	347.667
3135001	Jaguaraçu	MG	163.76
3135050	Jaíba	MG	2635.467
3135076	Jampruca	MG	517.095
2401008	Apodi	RN	1602.477
2401107	Areia Branca	RN	342.749
2401206	Arês	RN	115.407
2401701	Bom Jesus	RN	122.035
2401800	Brejinho	RN	61.559
3135100	Janaúba	MG	2181.319
3135209	Januária	MG	6661.588
3135308	Japaraíba	MG	172.141
3135357	Japonvar	MG	375.181
3135407	Jeceaba	MG	236.25
3135456	Jenipapo de Minas	MG	284.453
3135506	Jequeri	MG	547.897
3135605	Jequitaí	MG	1268.443
2401404	Baía Formosa	RN	247.484
3135704	Jequitibá	MG	445.03
2401503	Barcelona	RN	152.626
2401602	Bento Fernandes	RN	301.069
2401651	Bodó	RN	253.519
3135803	Jequitinhonha	MG	3514.216
2401859	Caiçara do Norte	RN	225.633
2401909	Caiçara do Rio do Vento	RN	261.194
2402402	Carnaúba dos Dantas	RN	246.308
3135902	Jesuânia	MG	153.852
2402006	Caicó	RN	1228.584
2402105	Campo Redondo	RN	213.727
2402907	Coronel João Pessoa	RN	117.139
3136009	Joaíma	MG	1664.19
3136108	Joanésia	MG	233.292
3136207	João Monlevade	MG	99.158
3136306	João Pinheiro	MG	10727.097
3136405	Joaquim Felício	MG	790.935
3136504	Jordânia	MG	546.705
3136520	José Gonçalves de Minas	MG	381.332
3136553	José Raydan	MG	180.822
3136579	Josenópolis	MG	541.393
3136603	Nova União	MG	172.131
2402204	Canguaretama	RN	245.485
2402303	Caraúbas	RN	1095.803
3136652	Juatuba	MG	97.017
3136702	Juiz de Fora	MG	1435.749
3136801	Juramento	MG	431.63
3136900	Juruaia	MG	220.353
3136959	Juvenília	MG	1064.692
3137007	Ladainha	MG	866.29
3137106	Lagamar	MG	1474.562
2403004	Cruzeta	RN	295.83
2403202	Doutor Severiano	RN	113.737
3137205	Lagoa da Prata	MG	439.984
3137304	Lagoa dos Patos	MG	600.547
3137403	Lagoa Dourada	MG	476.693
3137502	Lagoa Formosa	MG	840.92
3137536	Lagoa Grande	MG	1236.301
3137601	Lagoa Santa	MG	229.409
3137700	Lajinha	MG	431.92
3137809	Lambari	MG	213.11
3137908	Lamim	MG	118.602
3138005	Laranjal	MG	204.882
3138104	Lassance	MG	3204.217
3138203	Lavras	MG	564.744
3138302	Leandro Ferreira	MG	352.005
3138351	Leme do Prado	MG	280.036
3138401	Leopoldina	MG	943.077
3138500	Liberdade	MG	401.337
3138609	Lima Duarte	MG	848.564
3138625	Limeira do Oeste	MG	1317.153
2403103	Currais Novos	RN	864.349
2403301	Encanto	RN	125.749
3138658	Lontra	MG	258.925
3138674	Luisburgo	MG	145.418
3138682	Luislândia	MG	411.714
3138708	Luminárias	MG	500.143
3138807	Luz	MG	1171.659
2403251	Parnamirim	RN	124.006
3138906	Machacalis	MG	332.378
3139003	Machado	MG	585.958
2403608	Extremoz	RN	140.639
2403707	Felipe Guerra	RN	268.591
3139102	Madre de Deus de Minas	MG	492.909
3139201	Malacacheta	MG	727.886
3139250	Mamonas	MG	284.365
3139300	Manga	MG	1950.184
3139409	Manhuaçu	MG	628.318
3139508	Manhumirim	MG	182.9
3139607	Mantena	MG	685.208
3139706	Maravilhas	MG	261.604
3139805	Mar de Espanha	MG	371.6
3139904	Maria da Fé	MG	202.898
3140001	Mariana	MG	1194.208
3140100	Marilac	MG	158.809
3140159	Mário Campos	MG	35.196
3140209	Maripá de Minas	MG	77.338
2403806	Florânia	RN	507.892
2408409	Olho d'Água do Borges	RN	141.17
3140308	Marliéria	MG	545.813
3140407	Marmelópolis	MG	107.902
2403905	Francisco Dantas	RN	181.558
2404002	Frutuoso Gomes	RN	63.279
2405603	Jardim de Piranhas	RN	330.53
2404101	Galinhos	RN	340.769
2404200	Goianinha	RN	192.279
2404408	Grossos	RN	124.538
2404507	Guamaré	RN	258.307
3140506	Martinho Campos	MG	1058.418
3140530	Martins Soares	MG	113.268
3140555	Mata Verde	MG	227.539
3140605	Materlândia	MG	280.53
3140704	Mateus Leme	MG	301.383
3140803	Matias Barbosa	MG	157.066
3140852	Matias Cardoso	MG	1940.598
3140902	Matipó	MG	266.99
3141009	Mato Verde	MG	472.245
3141108	Matozinhos	MG	252.453
3141207	Matutina	MG	260.957
3141306	Medeiros	MG	946.437
3141405	Medina	MG	1435.903
3141504	Mendes Pimentel	MG	305.507
2404705	Ipanguaçu	RN	374.245
2404804	Ipueira	RN	127.348
2404853	Itajá	RN	203.624
3141603	Mercês	MG	348.271
3141702	Mesquita	MG	274.938
3141801	Minas Novas	MG	1812.398
3141900	Minduri	MG	219.774
3142007	Mirabela	MG	723.278
3142106	Miradouro	MG	301.672
3142205	Miraí	MG	320.695
3142254	Miravânia	MG	602.128
3142304	Moeda	MG	155.112
2405207	Janduís	RN	303.448
2405306	Januário Cicco	RN	170.737
2405405	Japi	RN	188.99
3142403	Moema	MG	202.705
3142502	Monjolos	MG	650.911
3142601	Monsenhor Paulo	MG	216.54
3142700	Montalvânia	MG	1503.755
3142809	Monte Alegre de Minas	MG	2595.957
3142908	Monte Azul	MG	1001.296
3143005	Monte Belo	MG	421.283
3143104	Monte Carmelo	MG	1343.035
2405702	Jardim do Seridó	RN	367.645
2405801	João Câmara	RN	714.961
3143153	Monte Formoso	MG	385.553
3143203	Monte Santo de Minas	MG	594.632
3143302	Montes Claros	MG	3589.811
3143401	Monte Sião	MG	291.594
3143450	Montezuma	MG	1130.419
3143500	Morada Nova de Minas	MG	2084.275
3143609	Morro da Garça	MG	414.772
3143708	Morro do Pilar	MG	477.548
2406106	Jucurutu	RN	933.73
2406155	Jundiá	RN	44.641
3143807	Munhoz	MG	191.564
3143906	Muriaé	MG	841.693
3144003	Mutum	MG	1250.824
3144102	Muzambinho	MG	409.948
3144201	Nacip Raydan	MG	233.493
3144300	Nanuque	MG	1518.166
2406502	Lagoa Nova	RN	176.302
2406601	Lagoa Salgada	RN	79.128
3144359	Naque	MG	127.173
3144375	Natalândia	MG	468.66
3144409	Natércia	MG	188.719
3144508	Nazareno	MG	341.453
3144607	Nepomuceno	MG	582.553
3144656	Ninheira	MG	1108.255
3144672	Nova Belém	MG	146.775
3144706	Nova Era	MG	361.926
3144805	Nova Lima	MG	429.313
3144904	Nova Módica	MG	375.973
3145000	Nova Ponte	MG	1111.011
3145059	Nova Porteirinha	MG	120.943
3145109	Nova Resende	MG	390.152
3145208	Nova Serrana	MG	282.472
2407104	Macaíba	RN	510.092
2407203	Macau	RN	775.302
2407252	Major Sales	RN	31.971
2407302	Marcelino Vieira	RN	345.711
2408508	Ouro Branco	RN	253.21
3145307	Novo Cruzeiro	MG	1702.981
3145356	Novo Oriente de Minas	MG	755.151
3145372	Novorizonte	MG	271.61
3145406	Olaria	MG	178.242
3145455	Olhos-d'Água	MG	2092.078
3145505	Olímpio Noronha	MG	54.633
3145604	Oliveira	MG	897.294
3145703	Oliveira Fortes	MG	111.13
2407401	Martins	RN	169.464
2407500	Maxaranguape	RN	132.129
2407609	Messias Targino	RN	142.608
2407708	Montanhas	RN	82.214
3145802	Onça de Pitangui	MG	246.976
2407807	Monte Alegre	RN	211.259
2407906	Monte das Gameleiras	RN	71.946
2408607	Paraná	RN	81.39
2408706	Paraú	RN	383.214
3145851	Oratórios	MG	89.068
3145877	Orizânia	MG	121.8
2408003	Mossoró	RN	2099.334
2408102	Natal	RN	167.401
2408201	Nísia Floresta	RN	307.719
2408300	Nova Cruz	RN	277.658
3145901	Ouro Branco	MG	258.726
3146008	Ouro Fino	MG	533.714
3146107	Ouro Preto	MG	1245.865
3146206	Ouro Verde de Minas	MG	175.482
3146255	Padre Carvalho	MG	446.275
2408904	Parelhas	RN	513.507
2409332	Santa Maria	RN	219.57
2409407	Pau dos Ferros	RN	259.959
3146305	Padre Paraíso	MG	544.375
3146404	Paineiras	MG	637.309
3146503	Pains	MG	421.862
3146552	Pai Pedro	MG	839.805
3146602	Paiva	MG	58.419
3146701	Palma	MG	316.476
3146750	Palmópolis	MG	433.154
3146909	Papagaios	MG	553.577
3147006	Paracatu	MG	8231.029
3147105	Pará de Minas	MG	551.247
2408953	Rio do Fogo	RN	151.097
2409100	Passa e Fica	RN	42.137
2409209	Passagem	RN	41.215
2409308	Patu	RN	319.135
2409506	Pedra Grande	RN	221.167
2409605	Pedra Preta	RN	294.985
2409704	Pedro Avelino	RN	952.755
2409803	Pedro Velho	RN	192.708
3147204	Paraguaçu	MG	424.296
3147303	Paraisópolis	MG	331.238
3147402	Paraopeba	MG	625.623
3147501	Passabém	MG	94.183
3147600	Passa Quatro	MG	277.221
3147709	Passa Tempo	MG	429.172
3147808	Passa Vinte	MG	246.565
3147907	Passos	MG	1338.07
2409902	Pendências	RN	419.137
2410009	Pilões	RN	82.69
2410108	Poço Branco	RN	230.401
2410603	Rafael Godeiro	RN	100.073
3147956	Patis	MG	444.196
3148004	Patos de Minas	MG	3190.456
3148103	Patrocínio	MG	2874.344
3148202	Patrocínio do Muriaé	MG	108.246
3148301	Paula Cândido	MG	268.321
3148400	Paulistas	MG	220.564
3148509	Pavão	MG	601.19
3148608	Peçanha	MG	996.646
2410207	Portalegre	RN	110.054
2411056	Tibau	RN	169.365
2410256	Porto do Mangue	RN	361.237
2410306	Serra Caiada	RN	217.539
2411106	Ruy Barbosa	RN	125.809
2410405	Pureza	RN	504.294
2410504	Rafael Fernandes	RN	78.231
3148707	Pedra Azul	MG	1594.651
3148756	Pedra Bonita	MG	173.928
3148806	Pedra do Anta	MG	173.168
3148905	Pedra do Indaiá	MG	347.92
3149002	Pedra Dourada	MG	69.99
3149101	Pedralva	MG	217.989
3149150	Pedras de Maria da Cruz	MG	1525.648
3149200	Pedrinópolis	MG	357.891
3149309	Pedro Leopoldo	MG	292.831
3149408	Pedro Teixeira	MG	112.959
3149507	Pequeri	MG	90.833
3149606	Pequi	MG	203.991
3149705	Perdigão	MG	249.322
3149804	Perdizes	MG	2451.112
3149903	Perdões	MG	270.657
3149952	Periquito	MG	228.907
3150000	Pescador	MG	317.463
3150109	Piau	MG	192.196
3150158	Piedade de Caratinga	MG	109.345
3150208	Piedade de Ponte Nova	MG	83.733
3150307	Piedade do Rio Grande	MG	322.814
3150406	Piedade dos Gerais	MG	259.638
2410702	Riacho da Cruz	RN	127.223
2410801	Riacho de Santana	RN	128.106
2410900	Riachuelo	RN	262.887
2411007	Rodolfo Fernandes	RN	154.84
3150505	Pimenta	MG	414.969
3150539	Pingo-d'Água	MG	66.57
2411205	Santa Cruz	RN	624.356
2411502	Santo Antônio	RN	301.082
3150570	Pintópolis	MG	1228.736
3150604	Piracema	MG	280.335
3150703	Pirajuba	MG	337.98
3150802	Piranga	MG	658.812
3150901	Piranguçu	MG	203.619
3151008	Piranguinho	MG	124.803
3151107	Pirapetinga	MG	190.681
3151206	Pirapora	MG	549.514
3151305	Piraúba	MG	144.289
3151404	Pitangui	MG	569.636
3151503	Piumhi	MG	902.468
3151602	Planura	MG	317.52
3151701	Poço Fundo	MG	474.244
3151800	Poços de Caldas	MG	546.958
3151909	Pocrane	MG	691.066
3152006	Pompéu	MG	2551.074
3152105	Ponte Nova	MG	470.643
3152131	Ponto Chique	MG	602.799
3152170	Ponto dos Volantes	MG	1212.413
3152204	Porteirinha	MG	1749.683
2411403	Santana do Matos	RN	1422.268
2411429	Santana do Seridó	RN	188.403
3152303	Porto Firme	MG	284.777
3152402	Poté	MG	625.111
3152501	Pouso Alegre	MG	542.797
3152600	Pouso Alto	MG	263.034
3152709	Prados	MG	264.115
3152808	Prata	MG	4847.544
3152907	Pratápolis	MG	215.516
3153004	Pratinha	MG	622.478
2411601	São Bento do Norte	RN	288.761
2411700	São Bento do Trairí	RN	190.818
3153103	Presidente Bernardes	MG	236.798
3153202	Presidente Juscelino	MG	695.882
3153301	Presidente Kubitschek	MG	189.235
3153400	Presidente Olegário	MG	3503.848
2411809	São Fernando	RN	404.427
2411908	São Francisco do Oeste	RN	75.588
2412104	São João do Sabugi	RN	277.011
3153509	Alto Jequitibá	MG	152.272
3153608	Prudente de Morais	MG	124.189
3153707	Quartel Geral	MG	556.436
3153806	Queluzito	MG	153.56
3153905	Raposos	MG	72.228
3154002	Raul Soares	MG	763.364
3154101	Recreio	MG	234.296
3154150	Reduto	MG	151.859
3154200	Resende Costa	MG	618.312
2412005	São Gonçalo do Amarante	RN	249.8
2413359	Serra do Mel	RN	620.241
3154309	Resplendor	MG	1081.796
3154408	Ressaquinha	MG	183.062
3154457	Riachinho	MG	1719.266
3154507	Riacho dos Machados	MG	1315.54
3154606	Ribeirão das Neves	MG	155.105
2412203	São José de Mipibu	RN	289.987
2412302	São José do Campestre	RN	341.115
3154705	Ribeirão Vermelho	MG	49.251
3154804	Rio Acima	MG	228.394
2412401	São José do Seridó	RN	174.505
2412500	São Miguel	RN	166.233
2413409	Serra Negra do Norte	RN	562.396
3154903	Rio Casca	MG	384.381
3155009	Rio Doce	MG	112.094
3155108	Rio do Prado	MG	479.815
3155207	Rio Espera	MG	238.602
3155306	Rio Manso	MG	231.54
3155405	Rio Novo	MG	209.31
3155504	Rio Paranaíba	MG	1352.353
3155603	Rio Pardo de Minas	MG	3117.675
2412559	São Miguel do Gostoso	RN	431.444
2412609	São Paulo do Potengi	RN	240.425
2412708	São Pedro	RN	195.237
3155702	Rio Piracicaba	MG	373.037
3155801	Rio Pomba	MG	252.418
3155900	Rio Preto	MG	348.046
3156007	Rio Vermelho	MG	986.561
2412807	São Rafael	RN	469.101
2412906	São Tomé	RN	862.585
3156106	Ritápolis	MG	404.805
3156205	Rochedo de Minas	MG	79.402
2413003	São Vicente	RN	197.817
2413102	Senador Elói de Souza	RN	152.376
2413201	Senador Georgino Avelino	RN	26.1
2413300	Serra de São Bento	RN	96.628
3156304	Rodeiro	MG	72.673
3156403	Romaria	MG	407.557
3156452	Rosário da Limeira	MG	111.156
3156502	Rubelita	MG	1110.295
3156601	Rubim	MG	965.174
3156700	Sabará	MG	302.453
3156809	Sabinópolis	MG	919.811
2413508	Serrinha	RN	193.351
2413557	Serrinha dos Pintos	RN	122.375
2413607	Severiano Melo	RN	157.85
3156908	Sacramento	MG	3073.268
3157005	Salinas	MG	1862.117
3157104	Salto da Divisa	MG	938.008
3157203	Santa Bárbara	MG	684.505
3157252	Santa Bárbara do Leste	MG	107.402
3157278	Santa Bárbara do Monte Verde	MG	417.925
3157302	Santa Bárbara do Tugúrio	MG	194.564
5209291	Guaraíta	GO	205.533
5209408	Guarani de Goiás	GO	1221.054
5209457	Guarinos	GO	593.188
5209606	Heitoraí	GO	228.615
5209705	Hidrolândia	GO	952.122
5209804	Hidrolina	GO	583.756
5209903	Iaciara	GO	1547.183
2413805	Taboleiro Grande	RN	124.093
2413904	Taipu	RN	352.818
2414001	Tangará	RN	339.484
3159001	Santana do Riacho	MG	677.207
3159100	Santana dos Montes	MG	196.565
3159209	Santa Rita de Caldas	MG	503.011
3159308	Santa Rita de Jacutinga	MG	420.94
3159357	Santa Rita de Minas	MG	68.153
3159407	Santa Rita de Ibitipoca	MG	324.234
3159506	Santa Rita do Itueto	MG	485.081
3159605	Santa Rita do Sapucaí	MG	352.969
3159704	Santa Rosa da Serra	MG	284.334
3159803	Santa Vitória	MG	2998.364
3159902	Santo Antônio do Amparo	MG	488.885
3160009	Santo Antônio do Aventureiro	MG	202.032
2414159	Tenente Laurentino Cruz	RN	68.556
2414209	Tibau do Sul	RN	102.68
3160108	Santo Antônio do Grama	MG	130.213
3160207	Santo Antônio do Itambé	MG	305.737
3160306	Santo Antônio do Jacinto	MG	503.706
3160405	Santo Antônio do Monte	MG	1125.78
3160454	Santo Antônio do Retiro	MG	796.29
3160504	Santo Antônio do Rio Abaixo	MG	107.269
3160603	Santo Hipólito	MG	430.656
3160702	Santos Dumont	MG	637.373
3160801	São Bento Abade	MG	80.403
2414506	Umarizal	RN	213.584
2414605	Upanema	RN	873.14
2414704	Várzea	RN	72.684
2414753	Venha-Ver	RN	71.621
3160900	São Brás do Suaçuí	MG	110.019
3160959	São Domingos das Dores	MG	60.865
2414803	Vera Cruz	RN	84.127
2414902	Viçosa	RN	37.905
2415008	Vila Flor	RN	47.656
3161007	São Domingos do Prata	MG	743.768
3161056	São Félix de Minas	MG	162.56
3161106	São Francisco	MG	3308.1
3161205	São Francisco de Paula	MG	316.822
3161304	São Francisco de Sales	MG	1128.864
3161403	São Francisco do Glória	MG	164.613
3161502	São Geraldo	MG	185.578
3161601	São Geraldo da Piedade	MG	152.336
3161650	São Geraldo do Baixio	MG	280.954
3161700	São Gonçalo do Abaeté	MG	2692.545
3161809	São Gonçalo do Pará	MG	265.73
2500106	Água Branca	PB	241.662
2500205	Aguiar	PB	351.607
2500304	Alagoa Grande	PB	322.071
2500403	Alagoa Nova	PB	128.23
3161908	São Gonçalo do Rio Abaixo	MG	363.828
3162005	São Gonçalo do Sapucaí	MG	516.683
3162104	São Gotardo	MG	866.087
3162203	São João Batista do Glória	MG	547.908
3162252	São João da Lagoa	MG	998.015
3162302	São João da Mata	MG	120.536
3162401	São João da Ponte	MG	1851.102
3162450	São João das Missões	MG	678.274
3162500	São João del Rei	MG	1452.002
3162559	São João do Manhuaçu	MG	143.096
3162575	São João do Manteninha	MG	137.928
3162609	São João do Oriente	MG	120.122
3162658	São João do Pacuí	MG	415.922
3162708	São João do Paraíso	MG	1925.575
3162807	São João Evangelista	MG	478.183
3162906	São João Nepomuceno	MG	407.427
3162922	São Joaquim de Bicas	MG	71.758
3162948	São José da Barra	MG	308.319
3162955	São José da Lapa	MG	47.93
2500502	Alagoinha	PB	111.361
2500536	Alcantil	PB	309.896
2500577	Algodão de Jandaíra	PB	222.74
2500601	Alhandra	PB	183.974
2500700	São João do Rio do Peixe	PB	476.238
2500734	Amparo	PB	122.094
2500775	Aparecida	PB	291.478
2500809	Araçagi	PB	232.177
2500908	Arara	PB	91.306
2502300	Bom Sucesso	PB	186.059
2501005	Araruna	PB	246.717
2501104	Areia	PB	269.13
2501153	Areia de Baraúnas	PB	114.078
2502409	Bonito de Santa Fé	PB	226.798
2502508	Boqueirão	PB	373.077
2502607	Igaracy	PB	197.058
3163003	São José da Safira	MG	213.881
3163102	São José da Varginha	MG	205.501
3163201	São José do Alegre	MG	88.794
3163300	São José do Divino	MG	328.704
3163409	São José do Goiabal	MG	189.578
3163508	São José do Jacuri	MG	345.146
3163607	São José do Mantimento	MG	54.701
2501203	Areial	PB	35.81
2501302	Aroeiras	PB	376.118
2501351	Assunção	PB	132.139
2501401	Baía da Traição	PB	102.756
2501500	Bananeiras	PB	255.641
3163706	São Lourenço	MG	58.019
3163805	São Miguel do Anta	MG	152.111
3163904	São Pedro da União	MG	260.827
3164001	São Pedro dos Ferros	MG	402.739
3164100	São Pedro do Suaçuí	MG	308.106
3164209	São Romão	MG	2434.004
3164308	São Roque de Minas	MG	2098.867
3164407	São Sebastião da Bela Vista	MG	167.428
3164431	São Sebastião da Vargem Alegre	MG	73.629
3164472	São Sebastião do Anta	MG	80.618
3164506	São Sebastião do Maranhão	MG	517.83
3164605	São Sebastião do Oeste	MG	408.09
3164704	São Sebastião do Paraíso	MG	814.925
3164803	São Sebastião do Rio Preto	MG	128.002
3164902	São Sebastião do Rio Verde	MG	90.848
3165008	São Tiago	MG	572.4
3165107	São Tomás de Aquino	MG	277.928
2501534	Baraúna	PB	50.03
2501575	Barra de Santana	PB	375.177
2501609	Barra de Santa Rosa	PB	781.187
2501708	Barra de São Miguel	PB	609.697
2501807	Bayeux	PB	27.705
2501906	Belém	PB	99.609
2502003	Belém do Brejo do Cruz	PB	601.549
3165206	São Tomé das Letras	MG	369.747
3165305	São Vicente de Minas	MG	392.651
3165404	Sapucaí-Mirim	MG	285.073
3165503	Sardoá	MG	141.904
3165537	Sarzedo	MG	62.134
3165552	Setubinha	MG	534.655
3165560	Sem-Peixe	MG	176.634
3165578	Senador Amaral	MG	151.097
3165602	Senador Cortes	MG	98.336
3165701	Senador Firmino	MG	166.495
3165800	Senador José Bento	MG	93.892
3165909	Senador Modestino Gonçalves	MG	952.055
3166006	Senhora de Oliveira	MG	170.749
3166105	Senhora do Porto	MG	381.328
3166204	Senhora dos Remédios	MG	237.815
3166303	Sericita	MG	166.012
3166402	Seritinga	MG	114.769
3166501	Serra Azul de Minas	MG	218.595
3166600	Serra da Saudade	MG	335.659
3166709	Serra dos Aimorés	MG	213.574
3166808	Serra do Salitre	MG	1295.272
3166907	Serrania	MG	209.27
3166956	Serranópolis de Minas	MG	551.954
3167004	Serranos	MG	213.173
2502052	Bernardino Batista	PB	57.453
2508554	Logradouro	PB	42.876
2508604	Lucena	PB	93.8
3167103	Serro	MG	1217.813
3167202	Sete Lagoas	MG	536.928
3167301	Silveirânia	MG	157.456
3167400	Silvianópolis	MG	312.166
3167509	Simão Pereira	MG	135.689
3167608	Simonésia	MG	486.543
3167707	Sobrália	MG	206.787
2502102	Boa Ventura	PB	168.664
2502151	Boa Vista	PB	468.933
2502201	Bom Jesus	PB	47.367
2511400	Picuí	PB	667.714
2511509	Pilar	PB	103.306
2511608	Pilões	PB	65.574
3167806	Soledade de Minas	MG	196.866
2502706	Borborema	PB	26.107
2502805	Brejo do Cruz	PB	401.315
2512036	Poço Dantas	PB	97.758
3167905	Tabuleiro	MG	211.084
3168002	Taiobeiras	MG	1220.046
3168051	Taparuba	MG	193.082
3168101	Tapira	MG	1179.248
2502904	Brejo dos Santos	PB	93.857
2503001	Caaporã	PB	151.018
2503100	Cabaceiras	PB	469.171
2503209	Cabedelo	PB	29.873
2503407	Cacimba de Areia	PB	213.018
3168200	Tapiraí	MG	407.92
3168309	Taquaraçu de Minas	MG	329.287
3168408	Tarumirim	MG	731.753
3168507	Teixeiras	MG	166.735
3168606	Teófilo Otoni	MG	3242.27
3168705	Timóteo	MG	144.381
3168804	Tiradentes	MG	83.047
2503308	Cachoeira dos Índios	PB	193.215
2504801	Coremas	PB	372.012
2503506	Cacimba de Dentro	PB	165.072
2503555	Cacimbas	PB	124.068
2503605	Caiçara	PB	123.677
2503704	Cajazeiras	PB	562.703
2503753	Cajazeirinhas	PB	282.693
2503803	Caldas Brandão	PB	55.963
2503902	Camalaú	PB	541.841
2504009	Campina Grande	PB	591.658
2504033	Capim	PB	79.876
2504074	Caraúbas	PB	486.622
3168903	Tiros	MG	2091.774
3169000	Tocantins	MG	173.866
3169059	Tocos do Moji	MG	114.705
3169109	Toledo	MG	136.776
3169208	Tombos	MG	285.124
3169307	Três Corações	MG	828.038
3169356	Três Marias	MG	2678.253
3169406	Três Pontas	MG	689.794
3169505	Tumiritinga	MG	500.073
3169604	Tupaciguara	MG	1822.53
3169703	Turmalina	MG	1153.111
3169802	Turvolândia	MG	221
3169901	Ubá	MG	407.452
3170008	Ubaí	MG	820.524
3170057	Ubaporanga	MG	189.045
3170107	Uberaba	MG	4523.957
3170206	Uberlândia	MG	4115.206
3170305	Umburatiba	MG	405.834
3170404	Unaí	MG	8445.432
3170438	União de Minas	MG	1147.407
3170479	Uruana de Minas	MG	598.221
2504108	Carrapateira	PB	59.07
2504157	Casserengue	PB	202.761
2504207	Catingueira	PB	527.424
2504306	Catolé do Rocha	PB	551.765
2504355	Caturité	PB	117.823
2504405	Conceição	PB	580.65
2504504	Condado	PB	265.473
2504603	Conde	PB	171.267
2505204	Cuitegi	PB	42.091
2505238	Cuité de Mamanguape	PB	107.68
2505279	Curral de Cima	PB	86.428
3170503	Urucânia	MG	138.792
3170529	Urucuia	MG	2076.942
3170578	Vargem Alegre	MG	116.664
3170602	Vargem Bonita	MG	409.888
3170651	Vargem Grande do Rio Pardo	MG	491.512
3170701	Varginha	MG	395.396
3170750	Varjão de Minas	MG	651.505
3170800	Várzea da Palma	MG	2220.279
3170909	Varzelândia	MG	814.994
2504702	Congo	PB	324.686
3171006	Vazante	MG	1913.396
3171030	Verdelândia	MG	1570.582
3171071	Veredinha	MG	631.692
3171105	Veríssimo	MG	1031.823
2504850	Coxixola	PB	173.942
3171154	Vermelho Novo	MG	115.242
3171204	Vespasiano	MG	71.04
3171303	Viçosa	MG	299.418
2504900	Cruz do Espírito Santo	PB	192.512
2505006	Cubati	PB	163.57
2505105	Cuité	PB	733.818
2505303	Curral Velho	PB	217.624
2505352	Damião	PB	186.198
2505402	Desterro	PB	182.018
3171402	Vieiras	MG	112.691
3171501	Mathias Lobato	MG	172.297
3171600	Virgem da Lapa	MG	868.914
3171709	Virgínia	MG	326.515
3171808	Virginópolis	MG	439.878
2505808	Duas Estradas	PB	27.012
2505907	Emas	PB	248.226
2506004	Esperança	PB	157.851
2506103	Fagundes	PB	185.061
2705903	Olho d'Água Grande	AL	117.006
2506202	Frei Martinho	PB	238.658
2506251	Gado Bravo	PB	192.42
2506301	Guarabira	PB	162.387
2506400	Gurinhém	PB	340.408
2506509	Gurjão	PB	344.502
2506608	Ibiara	PB	240.357
2506707	Imaculada	PB	317.804
2506806	Ingá	PB	262.179
2506905	Itabaiana	PB	210.572
2507002	Itaporanga	PB	460.21
2507101	Itapororoca	PB	145.806
2706604	Paulo Jacinto	AL	118.457
2706703	Penedo	AL	688.452
2706802	Piaçabuçu	AL	243.686
2507200	Itatuba	PB	251.749
2507309	Jacaraú	PB	256.845
2706901	Pilar	AL	259.614
2707008	Pindoba	AL	117.086
2707107	Piranhas	AL	403.995
3171907	Virgolândia	MG	281.022
3172004	Visconde do Rio Branco	MG	243.351
3172103	Volta Grande	MG	205.552
3172202	Wenceslau Braz	MG	102.487
3200102	Afonso Cláudio	ES	941.188
3200136	Águia Branca	ES	454.448
3200169	Água Doce do Norte	ES	473.729
3200201	Alegre	ES	756.86
3200300	Alfredo Chaves	ES	615.677
3200359	Alto Rio Novo	ES	227.617
3200409	Anchieta	ES	409.691
3200508	Apiacá	ES	193.984
3200607	Aracruz	ES	1420.285
3200706	Atílio Vivácqua	ES	232.868
3200805	Baixo Guandu	ES	909.039
3200904	Barra de São Francisco	ES	944.521
3201001	Boa Esperança	ES	428.716
3201100	Bom Jesus do Norte	ES	89.084
2507408	Jericó	PB	177.356
2507507	João Pessoa	PB	210.044
2507606	Juarez Távora	PB	75.678
3201159	Brejetuba	ES	354.404
3201209	Cachoeiro de Itapemirim	ES	864.583
3201308	Cariacica	ES	279.718
3201407	Castelo	ES	663.515
3201506	Colatina	ES	1398.219
3201605	Conceição da Barra	ES	1182.587
3201704	Conceição do Castelo	ES	369.778
3201803	Divino de São Lourenço	ES	174.039
3201902	Domingos Martins	ES	1229.21
3202009	Dores do Rio Preto	ES	159.298
3202108	Ecoporanga	ES	2285.369
3202207	Fundão	ES	286.854
3202256	Governador Lindenberg	ES	360.016
3202306	Guaçuí	ES	468.185
3202405	Guarapari	ES	589.825
3202454	Ibatiba	ES	240.278
3202504	Ibiraçu	ES	201.248
3202553	Ibitirama	ES	330.874
3202603	Iconha	ES	203.528
3202652	Irupi	ES	184.807
3202702	Itaguaçu	ES	535.021
3202801	Itapemirim	ES	550.71
3202900	Itarana	ES	295.189
3203007	Iúna	ES	460.586
3203056	Jaguaré	ES	659.751
3203106	Jerônimo Monteiro	ES	177.342
2507705	Juazeirinho	PB	474.606
3203130	João Neiva	ES	284.735
3203163	Laranja da Terra	ES	458.37
3203205	Linhares	ES	3496.263
5209937	Inaciolândia	GO	689.201
5209952	Indiara	GO	955.419
5210000	Inhumas	GO	614.887
2507804	Junco do Seridó	PB	180.425
2507903	Juripiranga	PB	78.706
2508000	Juru	PB	395.075
2508109	Lagoa	PB	176.649
2508208	Lagoa de Dentro	PB	83.508
2508307	Lagoa Seca	PB	108.219
3301009	Campos dos Goytacazes	RJ	4032.487
3301108	Cantagalo	RJ	747.21
3301157	Cardoso Moreira	RJ	522.596
3301207	Carmo	RJ	305.749
3301306	Casimiro de Abreu	RJ	462.918
3301405	Conceição de Macabu	RJ	338.26
3301504	Cordeiro	RJ	113.048
3301603	Duas Barras	RJ	379.619
3301702	Duque de Caxias	RJ	467.319
3301801	Engenheiro Paulo de Frontin	RJ	139.381
3301850	Guapimirim	RJ	358.443
5210109	Ipameri	GO	4382.863
5210158	Ipiranga de Goiás	GO	244.209
5210208	Iporá	GO	1027.249
5210307	Israelândia	GO	579.19
5210406	Itaberaí	GO	1461.916
5210562	Itaguari	GO	142.652
5210604	Itaguaru	GO	241.029
5210802	Itajá	GO	2082.736
5210901	Itapaci	GO	952.998
5211008	Itapirapuã	GO	2047.874
2508406	Lastro	PB	107.416
2508505	Livramento	PB	266.948
3305802	Teresópolis	RJ	773.338
3305901	Trajano de Moraes	RJ	591.151
3306008	Três Rios	RJ	322.843
3306107	Valença	RJ	1300.767
3306156	Varre-Sai	RJ	201.938
3306206	Vassouras	RJ	536.073
3306305	Volta Redonda	RJ	182.105
3500105	Adamantina	SP	411.987
3500204	Adolfo	SP	211.055
3500303	Aguaí	SP	474.554
3500402	Águas da Prata	SP	142.673
5211206	Itapuranga	GO	1281.404
5211305	Itarumã	GO	3437.367
5211404	Itauçu	GO	383.066
5211503	Itumbiara	GO	2447.014
5211602	Ivolândia	GO	1260.841
5211701	Jandaia	GO	863.087
5211800	Jaraguá	GO	1848.947
5211909	Jataí	GO	7178.792
5212006	Jaupaci	GO	528.783
5212055	Jesúpolis	GO	115.211
5212105	Joviânia	GO	446.258
5212204	Jussara	GO	4092.34
5212253	Lagoa Santa	GO	463.289
5212303	Leopoldo de Bulhões	GO	476.137
2508703	Mãe d'Água	PB	228.676
2508802	Malta	PB	172.01
2508901	Mamanguape	PB	337.434
5212501	Luziânia	GO	3962.107
5212600	Mairipotaba	GO	468.029
5212709	Mambaí	GO	858.27
5212808	Mara Rosa	GO	1695.463
5212907	Marzagão	GO	225.518
5212956	Matrinchã	GO	1150.503
5213004	Maurilândia	GO	389.959
5213053	Mimoso de Goiás	GO	1380.701
5213087	Minaçu	GO	2854.137
5213103	Mineiros	GO	9042.844
5213400	Moiporá	GO	452.314
5213509	Monte Alegre de Goiás	GO	3119.86
2509008	Manaíra	PB	352.025
2509057	Marcação	PB	122.665
2509107	Mari	PB	155.265
2509156	Marizópolis	PB	69.952
2509206	Massaranduba	PB	209.402
2509305	Mataraca	PB	182.439
2509339	Matinhas	PB	36.522
2509370	Mato Grosso	PB	85.275
2509396	Maturéia	PB	83.053
2509404	Mogeiro	PB	214.093
3500600	Águas de São Pedro	SP	3.612
2509503	Montadas	PB	31.793
2509602	Monte Horebe	PB	116.854
2509701	Monteiro	PB	992.62
2509800	Mulungu	PB	187.259
2509909	Natuba	PB	202.173
2510006	Nazarezinho	PB	193.203
2510105	Nova Floresta	PB	47.572
2510204	Nova Olinda	PB	81.516
2510303	Nova Palmeira	PB	314.748
2510402	Olho d'Água	PB	580.47
3500709	Agudos	SP	966.708
3500758	Alambari	SP	159.6
3500808	Alfredo Marcondes	SP	118.915
3500907	Altair	SP	313.007
3501004	Altinópolis	SP	928.956
3501103	Alto Alegre	SP	318.574
3501152	Alumínio	SP	83.619
3501202	Álvares Florence	SP	362.411
3501301	Álvares Machado	SP	347.647
3501400	Álvaro de Carvalho	SP	153.662
2510501	Olivedos	PB	314.625
2510600	Ouro Velho	PB	128.11
2510659	Parari	PB	207.814
2510709	Passagem	PB	123.422
2510808	Patos	PB	472.892
5213707	Montes Claros de Goiás	GO	2900.397
5213756	Montividiu	GO	1869.581
5213772	Montividiu do Norte	GO	1337.232
5213806	Morrinhos	GO	2846.299
5213855	Morro Agudo de Goiás	GO	282.333
5213905	Mossâmedes	GO	684.882
5214002	Mozarlândia	GO	1738.516
2510907	Paulista	PB	577.379
2511004	Pedra Branca	PB	116.873
2511103	Pedra Lavrada	PB	335.615
5214051	Mundo Novo	GO	2141.534
5214101	Mutunópolis	GO	955.069
5214408	Nazário	GO	281.147
5214507	Nerópolis	GO	204.713
5214606	Niquelândia	GO	9846.293
5214705	Nova América	GO	209.432
5214804	Nova Aurora	GO	307.335
5214838	Nova Crixás	GO	7308.681
5214861	Nova Glória	GO	411.753
5214879	Nova Iguaçu de Goiás	GO	625.625
5214903	Nova Roma	GO	2136.725
5215009	Nova Veneza	GO	122.354
5215207	Novo Brasil	GO	649.349
5215231	Novo Gama	GO	192.285
2511202	Pedras de Fogo	PB	406.729
2511301	Piancó	PB	576.986
2511707	Pilõezinhos	PB	40.908
2511806	Pirpirituba	PB	80.672
2511905	Pitimbu	PB	135.801
2512002	Pocinhos	PB	623.967
2513208	Santa Cruz	PB	217.677
2512077	Poço de José de Moura	PB	94.646
2512101	Pombal	PB	894.099
2513307	Santa Helena	PB	211.143
3533106	Nova Guataporanga	SP	34.158
3533205	Nova Independência	SP	265.029
3533254	Novais	SP	117.772
5215256	Novo Planalto	GO	1254.491
5215306	Orizona	GO	1971.265
2512200	Prata	PB	201.788
2512309	Princesa Isabel	PB	368.569
2512408	Puxinanã	PB	71.118
2512507	Queimadas	PB	402.748
2512606	Quixaba	PB	147.158
2512705	Remígio	PB	183.459
2512721	Pedro Régis	PB	74.216
2512747	Riachão	PB	85.291
3535705	Paraíso	SP	155.186
3535804	Paranapanema	SP	1018.724
3535903	Paranapuã	SP	140.354
3536000	Parapuã	SP	366.664
3536109	Pardinho	SP	209.894
3536208	Pariquera-Açu	SP	359.414
5215405	Ouro Verde de Goiás	GO	208.804
5215504	Ouvidor	GO	411.318
5215603	Padre Bernardo	GO	3142.615
5215652	Palestina de Goiás	GO	1318.047
5215702	Palmeiras de Goiás	GO	1537.196
5215801	Palmelo	GO	59.809
2512754	Riachão do Bacamarte	PB	40.281
2512762	Riachão do Poço	PB	40.46
2512788	Riacho de Santo Antônio	PB	93.654
2512804	Riacho dos Cavalos	PB	262.532
2512903	Rio Tinto	PB	465.24
2513000	Salgadinho	PB	179.005
2513109	Salgado de São Félix	PB	204.079
2513158	Santa Cecília	PB	217.577
3538907	Pirajuí	SP	823.758
3539004	Pirangi	SP	215.809
3539103	Pirapora do Bom Jesus	SP	108.489
3539202	Pirapozinho	SP	477.673
3539301	Pirassununga	SP	727.118
3539400	Piratininga	SP	402.409
3539509	Pitangueiras	SP	430.638
3539608	Planalto	SP	289.825
3539707	Platina	SP	327.48
3539806	Poá	SP	17.264
5215900	Palminópolis	GO	393.326
5216007	Panamá	GO	432.204
5216304	Paranaiguara	GO	1153.415
5216403	Paraúna	GO	3786.578
5216452	Perolândia	GO	1033.657
5216809	Petrolina de Goiás	GO	530.49
5216908	Pilar de Goiás	GO	906.048
5217104	Piracanjuba	GO	2374.232
5217203	Piranhas	GO	2045.088
5217302	Pirenópolis	GO	2200.369
5217401	Pires do Rio	GO	1077.641
2513356	Santa Inês	PB	327.635
2513406	Santa Luzia	PB	440.766
3541901	Queluz	SP	249.399
3542008	Quintana	SP	318.937
3542107	Rafard	SP	121.645
3542206	Rancharia	SP	1587.498
2513505	Santana de Mangueira	PB	405.164
2513604	Santana dos Garrotes	PB	361.484
2513653	Joca Claudino	PB	71.799
2513703	Santa Rita	PB	718.576
3542305	Redenção da Serra	SP	309.441
3542404	Regente Feijó	SP	263.28
3542503	Reginópolis	SP	410.406
3542602	Registro	SP	722.201
3542701	Restinga	SP	245.746
3542800	Ribeira	SP	335.759
3542909	Ribeirão Bonito	SP	471.553
3543006	Ribeirão Branco	SP	697.5
3543105	Ribeirão Corrente	SP	148.332
5217609	Planaltina	GO	2558.924
5217708	Pontalina	GO	1434.289
5218003	Porangatu	GO	4825.287
2513802	Santa Teresinha	PB	359.442
2513851	Santo André	PB	197.791
2513901	São Bento	PB	245.84
2513927	São Bentinho	PB	199.635
2513943	São Domingos do Cariri	PB	233.835
2513968	São Domingos	PB	170.361
2515609	Serra da Raiz	PB	31.679
2515708	Serra Grande	PB	64.352
3544103	Rio Grande da Serra	SP	36.341
3544202	Riolândia	SP	631.897
4302253	Boa Vista do Sul	RS	94.399
4302303	Bom Jesus	RS	2622.837
4302352	Bom Princípio	RS	88.66
2513984	São Francisco	PB	90.724
2514008	São João do Cariri	PB	612.966
2514107	São João do Tigre	PB	812.617
3546405	Santa Cruz do Rio Pardo	SP	1114.747
4302402	Bom Retiro do Sul	RS	102.54
4302451	Boqueirão do Leão	RS	265.952
4302501	Bossoroca	RS	1610.056
4302584	Bozano	RS	200.497
2514206	São José da Lagoa Tapada	PB	333.724
2514305	São José de Caiana	PB	183.273
2615409	Toritama	PE	25.704
3548906	São Carlos	SP	1136.907
4302600	Braga	RS	132.044
2514404	São José de Espinharas	PB	726.757
2514453	São José dos Ramos	PB	100.642
2514503	São José de Piranhas	PB	686.918
2514552	São José de Princesa	PB	158.052
2514602	São José do Bonfim	PB	153.629
2514651	São José do Brejo do Cruz	PB	253.787
2615706	Triunfo	PE	191.518
2615805	Tupanatinga	PE	934.801
2514701	São José do Sabugi	PB	213.555
2615904	Tuparetama	PE	189.509
3551306	Sebastianópolis do Sul	SP	167.848
3551405	Serra Azul	SP	283.144
3551504	Serrana	SP	126.046
3551603	Serra Negra	SP	203.734
3551702	Sertãozinho	SP	403.089
2514800	São José dos Cordeiros	PB	376.661
3551801	Sete Barras	SP	1062.699
5218052	Porteirão	GO	606.262
5218102	Portelândia	GO	553.411
5218300	Posse	GO	2076.99
5218391	Professor Jamil	GO	356.292
5218508	Quirinópolis	GO	3786.026
5218607	Rialma	GO	268.291
5218706	Rianápolis	GO	157.379
5218789	Rio Quente	GO	244.655
5218805	Rio Verde	GO	8374.255
5218904	Rubiataba	GO	750.659
5219001	Sanclerlândia	GO	509.402
5219100	Santa Bárbara de Goiás	GO	140.957
2514909	São Mamede	PB	533.446
2515005	São Miguel de Taipu	PB	92.413
2515104	São Sebastião de Lagoa de Roça	PB	46.372
2515203	São Sebastião do Umbuzeiro	PB	464.327
2515302	Sapé	PB	313.678
2515401	São Vicente do Seridó	PB	262.751
3553401	Tanabi	SP	747.218
3553500	Tapiraí	SP	755.1
3553609	Tapiratiba	SP	221.891
5219209	Santa Cruz de Goiás	GO	1109.007
5219258	Santa Fé de Goiás	GO	1164.186
5219308	Santa Helena de Goiás	GO	1142.337
5219357	Santa Isabel	GO	812.756
5219407	Santa Rita do Araguaia	GO	1357.197
5219456	Santa Rita do Novo Destino	GO	970.448
5219506	Santa Rosa de Goiás	GO	166.44
5219605	Santa Tereza de Goiás	GO	789.544
5219704	Santa Terezinha de Goiás	GO	1206.6
5219712	Santo Antônio da Barra	GO	450.336
5219738	Santo Antônio de Goiás	GO	135.022
5219753	Santo Antônio do Descoberto	GO	943.948
5219803	São Domingos	GO	3335.999
2515500	Serra Branca	PB	698.102
3555307	Turmalina	SP	147.797
3555356	Ubarana	SP	209.861
3555406	Ubatuba	SP	708.105
3555505	Ubirajara	SP	282.179
3555604	Uchoa	SP	252.434
5219902	São Francisco de Goiás	GO	416.535
5220009	São João d'Aliança	GO	3334.455
5220058	São João da Paraúna	GO	286.979
5220108	São Luís de Montes Belos	GO	829.62
5220157	São Luiz do Norte	GO	583.832
2515807	Serra Redonda	PB	55.197
2515906	Serraria	PB	65.062
5220207	São Miguel do Araguaia	GO	6150.179
5220264	São Miguel do Passa Quatro	GO	537.347
5220280	São Patrício	GO	172.763
5220405	São Simão	GO	415.015
5220454	Senador Canedo	GO	247.005
5220504	Serranópolis	GO	5521.774
5220603	Silvânia	GO	2349.924
5220686	Simolândia	GO	346.811
5220702	Sítio d'Abadia	GO	1611.851
5221007	Taquaral de Goiás	GO	205.665
5221080	Teresina de Goiás	GO	784.793
5221197	Terezópolis de Goiás	GO	107.407
5221304	Três Ranchos	GO	284.034
5221403	Trindade	GO	712.69
5221452	Trombas	GO	802.905
5221502	Turvânia	GO	482.317
5221551	Turvelândia	GO	935.659
2515930	Sertãozinho	PB	32.455
2515971	Sobrado	PB	61.953
2516003	Solânea	PB	233.043
2600609	Alagoinha	PE	214.267
2600708	Aliança	PE	272.773
2600807	Altinho	PE	450.178
2600906	Amaraji	PE	233.239
2516102	Soledade	PB	578.178
2602209	Bom Jardim	PE	224.108
2602308	Bonito	PE	393.191
5221577	Uirapuru	GO	1154.305
5221601	Uruaçu	GO	2142.484
5221700	Uruana	GO	522.904
5221809	Urutaí	GO	623.821
5221858	Valparaíso de Goiás	GO	61.488
5221908	Varjão	GO	517.402
5222005	Vianópolis	GO	954.115
5222054	Vicentinópolis	GO	733.794
5222203	Vila Boa	GO	1052.593
5222302	Vila Propício	GO	2181.593
5300108	Brasília	DF	5760.784
2516151	Sossêgo	PB	147.264
2516201	Sousa	PB	728.492
2516300	Sumé	PB	833.315
2516409	Tacima	PB	245.236
2516508	Taperoá	PB	628.365
2516607	Tavares	PB	239.507
2516706	Teixeira	PB	155.452
2516755	Tenório	PB	87.452
2516805	Triunfo	PB	224.336
2602704	Buenos Aires	PE	93.187
2602803	Buíque	PE	1336.544
2602902	Cabo de Santo Agostinho	PE	445.386
2603009	Cabrobó	PE	1658.616
2516904	Uiraúna	PB	293.182
2517001	Umbuzeiro	PB	185.578
2517100	Várzea	PB	191.282
2517209	Vieirópolis	PB	147.098
2517407	Zabelê	PB	106.811
2600054	Abreu e Lima	PE	126.384
2600104	Afogados da Ingazeira	PE	377.696
2600203	Afrânio	PE	1490.594
2600302	Agrestina	PE	200.369
2600401	Água Preta	PE	531.935
2603108	Cachoeirinha	PE	179.262
2600500	Águas Belas	PE	885.988
2601003	Angelim	PE	118.088
2601052	Araçoiaba	PE	96.36
2601102	Araripina	PE	2037.394
2601201	Arcoverde	PE	343.923
2616506	Xexéu	PE	110.815
2601300	Barra de Guabiraba	PE	118.639
2700102	Água Branca	AL	468.229
2700201	Anadia	AL	186.134
2700300	Arapiraca	AL	345.655
2700409	Atalaia	AL	533.258
2700508	Barra de Santo Antônio	AL	131.364
2601409	Barreiros	PE	233.433
2700706	Batalha	AL	315.87
2700805	Belém	AL	66.628
2700904	Belo Monte	AL	334.136
2601508	Belém de Maria	PE	73.145
2601607	Belém do São Francisco	PE	1830.797
2603603	Camutanga	PE	39.116
2601706	Belo Jardim	PE	647.445
2601805	Betânia	PE	1244.074
2601904	Bezerros	PE	492.632
2602001	Bodocó	PE	1621.786
2604007	Carpina	PE	147.017
2604106	Caruaru	PE	923.15
2602100	Bom Conselho	PE	792.185
2602407	Brejão	PE	159.786
2602506	Brejinho	PE	106.039
2602605	Brejo da Madre de Deus	PE	762.346
2603207	Caetés	PE	294.946
2603306	Calçado	PE	121.945
2603405	Calumbi	PE	179.314
2603454	Camaragibe	PE	51.321
2604155	Casinhas	PE	115.868
2604205	Catende	PE	208.594
2603504	Camocim de São Félix	PE	72.01
2607307	Ipubi	PE	693.914
2603702	Canhotinho	PE	423.168
2607406	Itacuruba	PE	430.038
2603801	Capoeiras	PE	337.13
2607505	Itaíba	PE	1061.694
2603900	Carnaíba	PE	427.802
2603926	Carnaubeira da Penha	PE	1004.667
2604304	Cedro	PE	148.746
2607802	Itaquitinga	PE	162.739
2607901	Jaboatão dos Guararapes	PE	258.724
2604403	Chã de Alegria	PE	49.327
2604502	Chã Grande	PE	84.787
2604601	Condado	PE	89.645
2604700	Correntes	PE	317.793
2604809	Cortês	PE	102.852
2608453	Lagoa do Carro	PE	69.666
2604908	Cumaru	PE	292.231
2605004	Cupira	PE	95.155
2605103	Custódia	PE	1404.126
2605152	Dormentes	PE	1539.052
2605202	Escada	PE	342.584
2605301	Exu	PE	1336.786
2605400	Feira Nova	PE	107.726
2605459	Fernando de Noronha	PE	18.609
2605509	Ferreiros	PE	92.516
2608503	Lagoa de Itaenga	PE	56.131
2605608	Flores	PE	995.558
2605707	Floresta	PE	3604.948
2605806	Frei Miguelinho	PE	212.707
2609204	Maraial	PE	199.865
2605905	Gameleira	PE	257.781
2606002	Garanhuns	PE	458.552
2606101	Glória do Goitá	PE	234.708
2606200	Goiana	PE	445.405
2606309	Granito	PE	521.69
2606408	Gravatá	PE	507.36
2606507	Iati	PE	635.137
2606606	Ibimirim	PE	1882.498
2606705	Ibirajuba	PE	189.596
2606804	Igarassu	PE	306.879
2606903	Iguaracy	PE	838.132
2607000	Inajá	PE	1231.362
2607109	Ingazeira	PE	243.586
2607208	Ipojuca	PE	521.801
2607604	Ilha de Itamaracá	PE	66.146
2607653	Itambé	PE	304.006
2607703	Itapetim	PE	411.901
2607752	Itapissuma	PE	73.968
2607950	Jaqueira	PE	87.208
2609501	Nazaré da Mata	PE	130.572
2609600	Olinda	PE	41.3
2609709	Orobó	PE	138.521
2608008	Jataúba	PE	714.601
2608057	Jatobá	PE	277.862
2608107	João Alfredo	PE	134.147
2608206	Joaquim Nabuco	PE	122.592
2608255	Jucati	PE	120.527
2608305	Jupi	PE	104.835
2608404	Jurema	PE	148.254
2608602	Lagoa do Ouro	PE	198.762
2611309	Pombos	PE	239.832
2608701	Lagoa dos Gatos	PE	224.947
2608750	Lagoa Grande	PE	1850.07
2608800	Lajedo	PE	189.096
2612406	Sanharó	PE	268.065
2612455	Santa Cruz	PE	1245.983
2608909	Limoeiro	PE	273.733
2609006	Macaparana	PE	108.049
2609105	Machados	PE	61.619
2609154	Manari	PE	344.685
2612471	Santa Cruz da Baixa Verde	PE	114.932
2609303	Mirandiba	PE	821.676
2609402	Moreno	PE	194.197
2609808	Orocó	PE	554.76
2609907	Ouricuri	PE	2381.57
2610103	Palmeirina	PE	168.796
2610004	Palmares	PE	339.401
2610202	Panelas	PE	380.428
2610301	Paranatama	PE	185.371
2610400	Parnamirim	PE	2609.548
2610509	Passira	PE	327.21
2610608	Paudalho	PE	269.651
2610707	Paulista	PE	96.932
2610806	Pedra	PE	922.602
2610905	Pesqueira	PE	960.042
2611002	Petrolândia	PE	1056.589
2611101	Petrolina	PE	4561.87
2611200	Poção	PE	205.119
2611408	Primavera	PE	113.135
2611507	Quipapá	PE	230.617
2611533	Quixaba	PE	210.705
2611606	Recife	PE	218.843
2611705	Riacho das Almas	PE	314.003
2611804	Ribeirão	PE	289.566
2611903	Rio Formoso	PE	227.458
2612000	Sairé	PE	190.455
2612109	Salgadinho	PE	87.217
2612208	Salgueiro	PE	1678.564
2612307	Saloá	PE	251.549
2612505	Santa Cruz do Capibaribe	PE	335.309
2612554	Santa Filomena	PE	1005.341
2612604	Santa Maria da Boa Vista	PE	3000.774
2612703	Santa Maria do Cambucá	PE	92.148
2612802	Santa Terezinha	PE	200.327
2612901	São Benedito do Sul	PE	160.477
2613008	São Bento do Una	PE	719.148
2613107	São Caitano	PE	382.483
2613206	São João	PE	258.519
2613800	São Vicente Férrer	PE	112.554
2613909	Serra Talhada	PE	2980.007
2614006	Serrita	PE	1535.19
2614105	Sertânia	PE	2421.527
2614204	Sirinhaém	PE	374.321
2614303	Moreilândia	PE	404.287
2613305	São Joaquim do Monte	PE	227.385
2613404	São José da Coroa Grande	PE	69.184
2614402	Solidão	PE	138.398
2613503	São José do Belmonte	PE	1474.086
2613602	São José do Egito	PE	774.037
2613701	São Lourenço da Mata	PE	263.687
2614501	Surubim	PE	252.896
2614600	Tabira	PE	390.434
2614709	Tacaimbó	PE	227.601
2614808	Tacaratu	PE	1264.532
2614857	Tamandaré	PE	213.75
2615003	Taquaritinga do Norte	PE	475.184
2615102	Terezinha	PE	151.45
2615201	Terra Nova	PE	318.709
2615300	Timbaúba	PE	287.683
2615508	Tracunhaém	PE	137.321
2615607	Trindade	PE	295.765
2616001	Venturosa	PE	336.107
2702108	Colônia Leopoldina	AL	207.935
2702207	Coqueiro Seco	AL	39.608
2702306	Coruripe	AL	897.8
2702355	Craíbas	AL	278.879
2702405	Delmiro Gouveia	AL	628.545
2616100	Verdejante	PE	476.039
2616183	Vertente do Lério	PE	73.631
2616209	Vertentes	PE	196.325
2616308	Vicência	PE	228.017
2616407	Vitória de Santo Antão	PE	336.573
2700607	Barra de São Miguel	AL	74.247
2701001	Boca da Mata	AL	193.002
2701100	Branquinha	AL	168.048
2701209	Cacimbinhas	AL	281.692
2701308	Cajueiro	AL	94.357
2701357	Campestre	AL	65.91
2701407	Campo Alegre	AL	312.726
2701506	Campo Grande	AL	170.144
2701605	Canapi	AL	602.778
2701704	Capela	AL	263.735
2702504	Dois Riachos	AL	141.621
2701803	Carneiros	AL	111.696
2702553	Estrela de Alagoas	AL	260.772
2702603	Feira Grande	AL	175.906
2702702	Feliz Deserto	AL	110.062
2702801	Flexeiras	AL	333.756
2702900	Girau do Ponciano	AL	513.454
2701902	Chã Preta	AL	157.831
2702009	Coité do Nóia	AL	88.759
2704906	Mar Vermelho	AL	91.741
2705002	Mata Grande	AL	914.722
2703007	Ibateguara	AL	265.312
2703106	Igaci	AL	334.346
2705101	Matriz de Camaragibe	AL	238.113
2705200	Messias	AL	114.156
2703205	Igreja Nova	AL	426.538
2705309	Minador do Negrão	AL	167.462
2705408	Monteirópolis	AL	86.604
2703304	Inhapi	AL	372.019
2705507	Murici	AL	418.028
2703403	Jacaré dos Homens	AL	148.992
2705705	Olho d'Água das Flores	AL	188.221
2705804	Olho d'Água do Casado	AL	327.678
2703502	Jacuípe	AL	208.738
2703601	Japaratinga	AL	85.356
2703700	Jaramataia	AL	105.416
2703759	Jequiá da Praia	AL	334.265
2703809	Joaquim Gomes	AL	298.17
2703908	Jundiá	AL	88.793
2704005	Junqueiro	AL	247.724
2704104	Lagoa da Canoa	AL	83.621
2704203	Limoeiro de Anadia	AL	309.205
2704302	Maceió	AL	509.32
2704401	Major Isidoro	AL	442.744
2704500	Maragogi	AL	334.165
2704609	Maravilha	AL	332.37
2704708	Marechal Deodoro	AL	340.98
2704807	Maribondo	AL	180.107
2705606	Novo Lino	AL	215.547
2706000	Olivença	AL	175.288
2706109	Ouro Branco	AL	196.56
2706208	Palestina	AL	38.189
2706307	Palmeira dos Índios	AL	450.99
2706406	Pão de Açúcar	AL	688.87
2706422	Pariconha	AL	254.719
2706448	Paripueira	AL	92.788
2706505	Passo de Camaragibe	AL	251.29
2707206	Poço das Trincheiras	AL	284.26
2707305	Porto Calvo	AL	313.231
2707404	Porto de Pedras	AL	257.105
2707503	Porto Real do Colégio	AL	235.852
2707701	Rio Largo	AL	293.816
2707602	Quebrangulo	AL	319.829
2707800	Roteiro	AL	128.926
2707909	Santa Luzia do Norte	AL	28.857
2708006	Santana do Ipanema	AL	436.16
2708105	Santana do Mundaú	AL	232.169
2709152	Teotônio Vilela	AL	299.221
2709202	Traipu	AL	681.577
2709301	União dos Palmares	AL	420.376
2708204	São Brás	AL	139.038
2708303	São José da Laje	AL	256.603
2708402	São José da Tapera	AL	490.879
2708501	São Luís do Quitunde	AL	397.257
2708600	São Miguel dos Campos	AL	335.683
2708709	São Miguel dos Milagres	AL	76.731
2708808	São Sebastião	AL	314.924
2800704	Brejo Grande	SE	141.464
2801009	Campo do Brito	SE	201.518
2708907	Satuba	AL	41.268
2802304	Frei Paulo	SE	399.178
2802403	Gararu	SE	656.956
2802502	General Maynard	SE	19.793
2802601	Gracho Cardoso	SE	242.679
2708956	Senador Rui Palmeira	AL	338.569
2709004	Tanque d'Arca	AL	124.617
2709103	Taquarana	AL	153.841
2807105	Simão Dias	SE	560.199
2807204	Siriri	SE	168.343
2807303	Telha	SE	47.86
2807402	Tobias Barreto	SE	1024.645
2807501	Tomar do Geru	SE	304.837
2709400	Viçosa	AL	367.888
2800100	Amparo do São Francisco	SE	35.683
2800209	Aquidabã	SE	359.543
2800308	Aracaju	SE	182.163
2800407	Arauá	SE	198.967
2901106	Amélia Rodrigues	BA	166.872
2901155	América Dourada	BA	822.373
2901205	Anagé	BA	1899.683
2901304	Andaraí	BA	1590.316
2901353	Andorinha	BA	1362.386
2901403	Angical	BA	1530.05
2800506	Areia Branca	SE	148.134
2902104	Araci	BA	1496.245
2902203	Aramari	BA	368.947
2902252	Arataca	BA	435.962
2902302	Aratuípe	BA	174.012
2902401	Aurelino Leal	BA	445.394
2902500	Baianópolis	BA	3320.723
2902609	Baixa Grande	BA	967.514
2902658	Banzaê	BA	409.507
2902708	Barra	BA	11428.112
2902807	Barra da Estiva	BA	1657.413
2902906	Barra do Choça	BA	765.936
2903003	Barra do Mendes	BA	1436.298
2903102	Barra do Rocha	BA	214.411
2903201	Barreiras	BA	8051.274
2903235	Barro Alto	BA	414.51
2903276	Barrocas	BA	207.297
2903300	Barro Preto	BA	201.585
2903409	Belmonte	BA	1939.447
2903508	Belo Campo	BA	772.756
2903607	Biritinga	BA	553.762
2903706	Boa Nova	BA	848.857
2903805	Boa Vista do Tupim	BA	2972.109
2903904	Bom Jesus da Lapa	BA	4115.51
2903953	Bom Jesus da Serra	BA	467.909
2904001	Boninal	BA	896.857
2904050	Bonito	BA	791.276
2904100	Boquira	BA	1426.233
2800605	Barra dos Coqueiros	SE	92.268
2800670	Boquim	SE	205.443
2801108	Canhoba	SE	171.581
2801207	Canindé de São Francisco	SE	934.167
2801306	Capela	SE	442.211
2801405	Carira	SE	638.743
2904209	Botuporã	BA	627.612
2904308	Brejões	BA	518.566
2904407	Brejolândia	BA	2247.208
2904506	Brotas de Macaúbas	BA	2520.817
2904605	Brumado	BA	2207.612
2904704	Buerarema	BA	219.487
2801504	Carmópolis	SE	46.395
2801603	Cedro de São João	SE	83.711
2801702	Cristinápolis	SE	228.556
2801900	Cumbe	SE	128.393
2802007	Divina Pastora	SE	90.508
2802106	Estância	SE	647.344
2802205	Feira Nova	SE	183.273
2904753	Buritirama	BA	4046.736
2802700	Ilha das Flores	SE	52.693
2802809	Indiaroba	SE	316.316
2802908	Itabaiana	SE	337.295
2803005	Itabaianinha	SE	501.794
2803104	Itabi	SE	183.422
2803203	Itaporanga d'Ajuda	SE	739.702
2803302	Japaratuba	SE	365.677
2803401	Japoatã	SE	402.353
2803500	Lagarto	SE	968.921
2803609	Laranjeiras	SE	162.273
2803708	Macambira	SE	137.496
2803807	Malhada dos Bois	SE	63.199
2803906	Malhador	SE	101.888
2904803	Caatiba	BA	512.436
2904852	Cabaceiras do Paraguaçu	BA	222.026
2904902	Cachoeira	BA	394.894
2905008	Caculé	BA	610.983
2905107	Caém	BA	540.908
2905156	Caetanos	BA	767.146
2905206	Caetité	BA	2651.536
2804003	Maruim	SE	95.554
2804102	Moita Bonita	SE	95.416
2804201	Monte Alegre de Sergipe	SE	386.912
2804300	Muribeca	SE	74.31
2804409	Neópolis	SE	271.323
2804458	Nossa Senhora Aparecida	SE	340.772
2804508	Nossa Senhora da Glória	SE	758.429
2804607	Nossa Senhora das Dores	SE	482.412
2906873	Capim Grosso	BA	464.776
2906899	Caraíbas	BA	805.629
2906907	Caravelas	BA	2377.889
2907004	Cardeal da Silva	BA	293.456
2907103	Carinhanha	BA	2525.906
2907202	Casa Nova	BA	9647.072
2907301	Castro Alves	BA	713.789
2907400	Catolândia	BA	702.504
2907509	Catu	BA	426.955
2907558	Caturama	BA	716.261
2804706	Nossa Senhora de Lourdes	SE	83.767
2804805	Nossa Senhora do Socorro	SE	155.018
2804904	Pacatuba	SE	381.428
2805000	Pedra Mole	SE	82.211
2805109	Pedrinhas	SE	33.344
2805208	Pinhão	SE	156.373
2805307	Pirambu	SE	208.681
2805406	Poço Redondo	SE	1220.426
2805505	Poço Verde	SE	441.326
2805604	Porto da Folha	SE	878.043
2805703	Propriá	SE	96.32
2805802	Riachão do Dantas	SE	530.607
2805901	Riachuelo	SE	78.308
2806008	Ribeirópolis	SE	259.044
2908606	Conde	BA	931.106
2908705	Condeúba	BA	1348.039
2908804	Contendas do Sincorá	BA	977.455
2908903	Coração de Maria	BA	378.42
2909000	Cordeiros	BA	523.64
2909109	Coribe	BA	2662.819
2909208	Coronel João Sá	BA	797.434
2909307	Correntina	BA	11504.314
2909406	Cotegipe	BA	4282.775
2909505	Cravolândia	BA	182.585
2909604	Crisópolis	BA	636.609
2909703	Cristópolis	BA	1052.837
2909802	Cruz das Almas	BA	139.117
2909901	Curaçá	BA	5950.614
2910008	Dário Meira	BA	413.637
2910057	Dias d'Ávila	BA	183.759
2910107	Dom Basílio	BA	689.516
2910206	Dom Macedo Costa	BA	94.778
2910305	Elísio Medrado	BA	179.329
2910404	Encruzilhada	BA	1890.133
2910503	Entre Rios	BA	1187.766
2910602	Esplanada	BA	1299.355
2910701	Euclides da Cunha	BA	2025.368
2910727	Eunápolis	BA	1425.97
2910750	Fátima	BA	364.419
2910776	Feira da Mata	BA	1176.111
2910800	Feira de Santana	BA	1304.425
2806107	Rosário do Catete	SE	102.683
2910859	Filadélfia	BA	579.686
2806206	Salgado	SE	247.579
2806305	Santa Luzia do Itanhy	SE	325.258
2806404	Santana do São Francisco	SE	44.017
2806503	Santa Rosa de Lima	SE	67.672
2806602	Santo Amaro das Brotas	SE	236.965
2806701	São Cristóvão	SE	438.037
2806800	São Domingos	SE	101.999
2806909	São Francisco	SE	83.985
2807006	São Miguel do Aleixo	SE	144.868
2807600	Umbaúba	SE	117.514
2900108	Abaíra	BA	538.677
2900207	Abaré	BA	1604.923
2900306	Acajutiba	BA	181.475
2900355	Adustina	BA	629.099
2900405	Água Fria	BA	742.775
2900504	Érico Cardoso	BA	735.249
2900603	Aiquara	BA	167.877
2900702	Alagoinhas	BA	707.835
2900801	Alcobaça	BA	1477.929
2900900	Almadina	BA	245.236
2901007	Amargosa	BA	431.655
2901502	Anguera	BA	187.84
2901601	Antas	BA	319.745
2901700	Antônio Cardoso	BA	293.53
2901809	Antônio Gonçalves	BA	345.284
2901908	Aporá	BA	479.262
2901957	Apuarema	BA	150.83
2902005	Aracatu	BA	1489.803
2902054	Araçás	BA	474.577
2905305	Cafarnaum	BA	643.66
2905404	Cairu	BA	448.846
2913705	Inhambupe	BA	1082.283
2913804	Ipecaetá	BA	372.565
2913903	Ipiaú	BA	280.454
2914000	Ipirá	BA	3105.281
2914109	Ipupiara	BA	1055.76
2914208	Irajuba	BA	459.047
2914307	Iramaia	BA	1708.115
2914406	Iraquara	BA	991.822
2914505	Irará	BA	267.88
2914604	Irecê	BA	319.174
2914653	Itabela	BA	924.914
2914703	Itaberaba	BA	2386.39
2914802	Itabuna	BA	401.028
2905503	Caldeirão Grande	BA	458.311
2905602	Camacan	BA	584.848
2905701	Camaçari	BA	785.421
2905800	Camamu	BA	839.702
2905909	Campo Alegre de Lourdes	BA	2914.587
2906006	Campo Formoso	BA	7161.827
2906105	Canápolis	BA	460.388
2906204	Canarana	BA	579.726
2906303	Canavieiras	BA	1334.284
2906402	Candeal	BA	447.578
2906501	Candeias	BA	251.808
2914901	Itacaré	BA	726.265
2915007	Itaeté	BA	1331.822
2915106	Itagi	BA	310.621
2915205	Itagibá	BA	810.993
2915304	Itagimirim	BA	876.8
2915353	Itaguaçu da Bahia	BA	4310.238
2915403	Itaju do Colônia	BA	1225.287
2915502	Itajuípe	BA	270.752
2915601	Itamaraju	BA	2360.584
2915700	Itamari	BA	143.479
2915809	Itambé	BA	1534.575
2915908	Itanagra	BA	533.634
2916005	Itanhém	BA	1394.174
2906600	Candiba	BA	433.642
2906709	Cândido Sales	BA	1169.814
2906808	Cansanção	BA	1351.891
2906824	Canudos	BA	3565.377
2906857	Capela do Alto Alegre	BA	629.586
2907608	Central	BA	566.974
2907707	Chorrochó	BA	3005.319
2907806	Cícero Dantas	BA	819.969
2907905	Cipó	BA	168.33
2908002	Coaraci	BA	274.5
2908101	Cocos	BA	10140.572
2908200	Conceição da Feira	BA	164.798
2908309	Conceição do Almeida	BA	284.836
2908408	Conceição do Coité	BA	1015.252
2908507	Conceição do Jacuípe	BA	114.869
2910909	Firmino Alves	BA	172.353
2911006	Floresta Azul	BA	321.013
2911105	Formosa do Rio Preto	BA	15634.328
2911204	Gandu	BA	229.661
2911253	Gavião	BA	384.592
2911303	Gentio do Ouro	BA	3817.946
2911402	Glória	BA	1566.609
2911501	Gongogi	BA	202.194
2919306	Lençóis	BA	1283.328
2911600	Governador Mangabeira	BA	106.848
2911659	Guajeru	BA	872.867
2911709	Guanambi	BA	1272.366
2911808	Guaratinga	BA	2189.404
2911857	Heliópolis	BA	313.438
2911907	Iaçu	BA	2342.497
2912004	Ibiassucê	BA	483.274
2912103	Ibicaraí	BA	230.953
2912202	Ibicoara	BA	817.355
2912301	Ibicuí	BA	1139.378
2912400	Ibipeba	BA	1382.008
2912509	Ibipitanga	BA	954.373
2912608	Ibiquera	BA	698.245
2912707	Ibirapitanga	BA	472.664
2912806	Ibirapuã	BA	771.098
2912905	Ibirataia	BA	318.129
2913002	Ibitiara	BA	1834.002
2913101	Ibititá	BA	573.033
2913200	Ibotirama	BA	1740.113
2919405	Licínio de Almeida	BA	856.626
2919504	Livramento de Nossa Senhora	BA	1952.51
2919553	Luís Eduardo Magalhães	BA	4036.094
2919603	Macajuba	BA	701.171
2919702	Macarani	BA	1210.106
2919801	Macaúbas	BA	2459.102
2919900	Macururé	BA	2545.856
2913309	Ichu	BA	138.016
2913408	Igaporã	BA	836.586
2913457	Igrapiúna	BA	591.312
2913507	Iguaí	BA	860.223
2913606	Ilhéus	BA	1588.555
2916104	Itaparica	BA	121.373
2916203	Itapé	BA	453.144
2916302	Itapebi	BA	1013.074
2916401	Itapetinga	BA	1651.158
2916500	Itapicuru	BA	1557.685
2916609	Itapitanga	BA	420.663
2916708	Itaquara	BA	344.093
2916807	Itarantim	BA	1674.029
2916856	Itatim	BA	547.51
2916906	Itiruçu	BA	322.243
2917003	Itiúba	BA	1650.593
2917102	Itororó	BA	313.839
2917201	Ituaçu	BA	1199.374
2917300	Ituberá	BA	415.428
2917334	Iuiu	BA	1525.142
2917359	Jaborandi	BA	9955.113
2917409	Jacaraci	BA	1332.42
2917508	Jacobina	BA	2192.905
2917607	Jaguaquara	BA	924.512
2917706	Jaguarari	BA	2466.009
2917805	Jaguaripe	BA	863.424
2917904	Jandaíra	BA	640.772
2918001	Jequié	BA	2969.039
2918100	Jeremoabo	BA	4267.488
2918209	Jiquiriçá	BA	238.66
2918308	Jitaúna	BA	262.05
2918357	João Dourado	BA	913.258
2918407	Juazeiro	BA	6721.237
2918456	Jucuruçu	BA	1457.656
2918506	Jussara	BA	1355.173
2918555	Jussari	BA	329.19
2918605	Jussiape	BA	589.763
2918704	Lafaiete Coutinho	BA	498.11
2918753	Lagoa Real	BA	912.222
2918803	Laje	BA	449.834
2918902	Lajedão	BA	624.353
2919009	Lajedinho	BA	846.728
2919058	Lajedo do Tabocal	BA	382.937
2919108	Lamarão	BA	189.257
2919157	Lapão	BA	642.882
2919207	Lauro de Freitas	BA	57.942
2922052	Mulungu do Morro	BA	646.621
2922730	Nova Fátima	BA	346.784
2922755	Nova Ibiá	BA	203.198
2922805	Nova Itarana	BA	475.381
2922854	Nova Redenção	BA	565.356
2922904	Nova Soure	BA	966.993
2923001	Nova Viçosa	BA	1316.379
2923035	Novo Horizonte	BA	627.5
2923050	Novo Triunfo	BA	278.487
2923100	Olindina	BA	637.317
2923209	Oliveira dos Brejinhos	BA	3313.418
2923308	Ouriçangas	BA	156.982
2923357	Ourolândia	BA	1544.988
2923407	Palmas de Monte Alto	BA	2560.027
2923506	Palmeiras	BA	737.454
2923605	Paramirim	BA	1087.06
2923704	Paratinga	BA	2624.998
2923803	Paripiranga	BA	442.186
2927309	Salinas da Margarida	BA	150.569
2927408	Salvador	BA	693.442
2927507	Santa Bárbara	BA	347.021
2927606	Santa Brígida	BA	934.461
2927705	Santa Cruz Cabrália	BA	1462.942
2927804	Santa Cruz da Vitória	BA	284.083
2927903	Santa Inês	BA	379.27
2928000	Santaluz	BA	1623.445
2932804	Utinga	BA	633.76
2932903	Valença	BA	1123.975
2933000	Valente	BA	394.877
2933059	Várzea da Roça	BA	468.407
2933109	Várzea do Poço	BA	206.478
2933158	Várzea Nova	BA	1225.892
2933174	Varzedo	BA	221.399
2933208	Vera Cruz	BA	297.537
2933257	Vereda	BA	782.159
2933307	Vitória da Conquista	BA	3254.186
2933406	Wagner	BA	522.37
2933455	Wanderley	BA	2920.579
2933505	Wenceslau Guimarães	BA	655.057
2933604	Xique-Xique	BA	5079.662
3100104	Abadia dos Dourados	MG	880.461
3100203	Abaeté	MG	1817.067
3100302	Abre Campo	MG	470.551
3100401	Acaiaca	MG	101.886
3100500	Açucena	MG	815.422
3100609	Água Boa	MG	1320.344
3100708	Água Comprida	MG	492.167
3100807	Aguanil	MG	232.091
3100906	Águas Formosas	MG	820.079
3101003	Águas Vermelhas	MG	1256.607
3101102	Aimorés	MG	1348.913
3101201	Aiuruoca	MG	649.68
3101300	Alagoa	MG	161.356
3101409	Albertina	MG	58.01
3101508	Além Paraíba	MG	510.25
3101607	Alfenas	MG	850.446
3101631	Alfredo Vasconcelos	MG	130.815
3101706	Almenara	MG	2294.426
3101805	Alpercata	MG	166.972
3101904	Alpinópolis	MG	460.685
3102001	Alterosa	MG	362.01
3102050	Alto Caparaó	MG	103.69
3102100	Alto Rio Doce	MG	518.053
3102209	Alvarenga	MG	278.175
3102308	Alvinópolis	MG	599.443
3102407	Alvorada de Minas	MG	374.008
3102506	Amparo do Serra	MG	136.186
3102605	Andradas	MG	469.396
3102704	Cachoeira de Pajeú	MG	695.672
3102803	Andrelândia	MG	1005.285
3102852	Angelândia	MG	185.211
3102902	Antônio Carlos	MG	529.915
3103009	Antônio Dias	MG	787.061
3103108	Antônio Prado de Minas	MG	83.802
3103207	Araçaí	MG	187.538
3103306	Aracitaba	MG	106.608
3103405	Araçuaí	MG	2236.279
3103504	Araguari	MG	2729.777
3103603	Arantina	MG	89.42
3157336	Santa Cruz de Minas	MG	3.565
3157377	Santa Cruz de Salinas	MG	589.607
3157401	Santa Cruz do Escalvado	MG	258.726
3157500	Santa Efigênia de Minas	MG	131.965
3157609	Santa Fé de Minas	MG	2917.448
3157658	Santa Helena de Minas	MG	276.433
3157708	Santa Juliana	MG	723.784
3157807	Santa Luzia	MG	235.205
3157906	Santa Margarida	MG	255.73
3158003	Santa Maria de Itabira	MG	597.441
3158102	Santa Maria do Salto	MG	440.605
3158201	Santa Maria do Suaçuí	MG	624.047
3158300	Santana da Vargem	MG	172.444
3158409	Santana de Cataguases	MG	161.486
3158508	Santana de Pirapama	MG	1255.832
3158607	Santana do Deserto	MG	182.655
3158706	Santana do Garambéu	MG	203.074
3158805	Santana do Jacaré	MG	106.169
3158904	Santana do Manhuaçu	MG	347.362
3158953	Santana do Paraíso	MG	276.067
3203304	Mantenópolis	ES	321.418
3203320	Marataízes	ES	130.268
3203346	Marechal Floriano	ES	285.495
3203353	Marilândia	ES	327.642
3203403	Mimoso do Sul	ES	869.439
3203502	Montanha	ES	1099.06
3203601	Mucurici	ES	540.529
3203700	Muniz Freire	ES	678.804
3203809	Muqui	ES	327.268
3203908	Nova Venécia	ES	1439.571
3204005	Pancas	ES	837.842
3204054	Pedro Canário	ES	433.453
3204104	Pinheiros	ES	973.136
3204203	Piúma	ES	74.046
3204252	Ponto Belo	ES	360.11
3204302	Presidente Kennedy	ES	594.897
3204351	Rio Bananal	ES	641.929
3204401	Rio Novo do Sul	ES	204.464
3204500	Santa Leopoldina	ES	718.325
3204559	Santa Maria de Jetibá	ES	735.198
3204609	Santa Teresa	ES	683.032
3204658	São Domingos do Norte	ES	298.58
3204708	São Gabriel da Palha	ES	434.887
3204807	São José do Calçado	ES	273.489
3204906	São Mateus	ES	2346.049
3204955	São Roque do Canaã	ES	341.944
3205002	Serra	ES	547.631
3205010	Sooretama	ES	587.036
3205036	Vargem Alta	ES	417.76
3205069	Venda Nova do Imigrante	ES	185.909
3205101	Viana	ES	312.279
3205150	Vila Pavão	ES	433.257
3205176	Vila Valério	ES	470.343
3205200	Vila Velha	ES	210.225
3205309	Vitória	ES	97.123
3300100	Angra dos Reis	RJ	813.42
3300159	Aperibé	RJ	94.542
3300209	Araruama	RJ	638.276
3300225	Areal	RJ	110.724
3300233	Armação dos Búzios	RJ	70.977
3300258	Arraial do Cabo	RJ	152.106
3300308	Barra do Piraí	RJ	584.61
3300407	Barra Mansa	RJ	547.133
3300456	Belford Roxo	RJ	78.985
3300506	Bom Jardim	RJ	382.43
3300605	Bom Jesus do Itabapoana	RJ	596.659
3300704	Cabo Frio	RJ	413.449
3300803	Cachoeiras de Macacu	RJ	954.749
3300902	Cambuci	RJ	558.281
3300936	Carapebus	RJ	304.885
3300951	Comendador Levy Gasparian	RJ	108.639
3301876	Iguaba Grande	RJ	50.977
3301900	Itaboraí	RJ	429.961
3302007	Itaguaí	RJ	282.606
3302056	Italva	RJ	291.193
3302106	Itaocara	RJ	433.182
3302205	Itaperuna	RJ	1106.694
3302254	Itatiaia	RJ	241.035
3302270	Japeri	RJ	81.697
3302304	Laje do Muriaé	RJ	253.53
3302403	Macaé	RJ	1216.989
3302452	Macuco	RJ	78.364
3302502	Magé	RJ	390.775
3302601	Mangaratiba	RJ	367.606
3302700	Maricá	RJ	361.572
3302809	Mendes	RJ	95.324
3302858	Mesquita	RJ	41.169
3302908	Miguel Pereira	RJ	287.933
3303005	Miracema	RJ	303.27
3303104	Natividade	RJ	387.073
3303203	Nilópolis	RJ	19.393
3303302	Niterói	RJ	133.757
3303401	Nova Friburgo	RJ	935.429
3303500	Nova Iguaçu	RJ	520.581
3303609	Paracambi	RJ	190.949
3303708	Paraíba do Sul	RJ	571.118
3303807	Paraty	RJ	924.296
3303856	Paty do Alferes	RJ	314.341
3303906	Petrópolis	RJ	791.144
3303955	Pinheiral	RJ	82.254
3304003	Piraí	RJ	490.255
3304102	Porciúncula	RJ	291.847
3304110	Porto Real	RJ	50.892
3304128	Quatis	RJ	284.826
3304144	Queimados	RJ	75.927
3304151	Quissamã	RJ	719.643
3304201	Resende	RJ	1099.336
3304300	Rio Bonito	RJ	459.458
3304409	Rio Claro	RJ	846.797
3304508	Rio das Flores	RJ	478.783
3304524	Rio das Ostras	RJ	228.044
3304557	Rio de Janeiro	RJ	1200.329
3304607	Santa Maria Madalena	RJ	810.963
3304706	Santo Antônio de Pádua	RJ	603.633
3304755	São Francisco de Itabapoana	RJ	1118.037
3304805	São Fidélis	RJ	1034.833
3304904	São Gonçalo	RJ	248.16
3305000	São João da Barra	RJ	452.396
3305109	São João de Meriti	RJ	35.216
3305133	São José de Ubá	RJ	249.688
3305158	São José do Vale do Rio Preto	RJ	220.178
3305208	São Pedro da Aldeia	RJ	332.488
3305307	São Sebastião do Alto	RJ	397.214
3305406	Sapucaia	RJ	540.673
3305505	Saquarema	RJ	352.13
3305554	Seropédica	RJ	265.189
3305604	Silva Jardim	RJ	937.755
3305703	Sumidouro	RJ	413.407
3305752	Tanguá	RJ	143.007
3500501	Águas de Lindóia	SP	60.126
3500550	Águas de Santa Bárbara	SP	404.463
3501509	Alvinlândia	SP	84.879
3501608	Americana	SP	133.912
3501707	Américo Brasiliense	SP	122.958
3501806	Américo de Campos	SP	252.876
3501905	Amparo	SP	445.323
3502002	Analândia	SP	325.953
3502101	Andradina	SP	964.226
3502200	Angatuba	SP	1027.288
3502309	Anhembi	SP	736.557
3502408	Anhumas	SP	320.84
3502507	Aparecida	SP	120.89
3502606	Aparecida d'Oeste	SP	179.004
3502705	Apiaí	SP	974.322
3502754	Araçariguama	SP	145.204
3502804	Araçatuba	SP	1167.126
3502903	Araçoiaba da Serra	SP	255.305
3503000	Aramina	SP	202.829
3503109	Arandu	SP	285.908
3503158	Arapeí	SP	156.903
3503208	Araraquara	SP	1003.625
3503307	Araras	SP	644.831
3503356	Arco-Íris	SP	264.904
3503406	Arealva	SP	506.226
3503505	Areias	SP	305.227
3503604	Areiópolis	SP	85.907
3503703	Ariranha	SP	132.624
3503802	Artur Nogueira	SP	178.026
3503901	Arujá	SP	96.167
3503950	Aspásia	SP	69.373
3504008	Assis	SP	460.609
3504107	Atibaia	SP	478.521
3504206	Auriflama	SP	434.498
3504305	Avaí	SP	540.689
3504404	Avanhandava	SP	338.37
3504503	Avaré	SP	1213.055
3504602	Bady Bassitt	SP	110.372
3504701	Balbinos	SP	91.635
3507308	Boracéia	SP	122.11
3507407	Borborema	SP	552.256
3507456	Borebi	SP	347.989
3507506	Botucatu	SP	1482.642
3507605	Bragança Paulista	SP	512.584
3504800	Bálsamo	SP	149.881
3504909	Bananal	SP	616.429
3505005	Barão de Antonina	SP	153.142
3505104	Barbosa	SP	205.212
3505203	Bariri	SP	444.405
3507704	Braúna	SP	195.176
3505302	Barra Bonita	SP	150.121
3505351	Barra do Chapéu	SP	405.681
3505401	Barra do Turvo	SP	1007.684
3505500	Barretos	SP	1566.161
3505609	Barrinha	SP	146.025
3505708	Barueri	SP	65.701
3505807	Bastos	SP	170.912
3505906	Batatais	SP	849.526
3506003	Bauru	SP	667.684
3506102	Bebedouro	SP	683.192
3506201	Bento de Abreu	SP	301.687
3506300	Bernardino de Campos	SP	244.158
3506359	Bertioga	SP	491.546
3506409	Bilac	SP	158.025
3506508	Birigui	SP	530.031
3506607	Biritiba Mirim	SP	317.406
3506706	Boa Esperança do Sul	SP	690.748
3506805	Bocaina	SP	363.926
3506904	Bofete	SP	653.541
3507001	Boituva	SP	248.954
3507100	Bom Jesus dos Perdões	SP	108.366
3509700	Campos do Jordão	SP	289.981
3509809	Campos Novos Paulista	SP	484.199
3509908	Cananéia	SP	1237.354
3507159	Bom Sucesso de Itararé	SP	133.578
3507209	Borá	SP	118.951
3507753	Brejo Alegre	SP	105.689
3507803	Brodowski	SP	278.458
3507902	Brotas	SP	1101.373
3508009	Buri	SP	1196.463
3508108	Buritama	SP	326.921
3508207	Buritizal	SP	266.42
3508306	Cabrália Paulista	SP	239.974
3508405	Cabreúva	SP	260.234
3508504	Caçapava	SP	368.99
3508603	Cachoeira Paulista	SP	287.99
3508702	Caconde	SP	468.214
3508801	Cafelândia	SP	920.28
3508900	Caiabu	SP	253.352
3509007	Caieiras	SP	97.642
3509106	Caiuá	SP	551.159
3509205	Cajamar	SP	131.386
3509254	Cajati	SP	454.436
3509304	Cajobi	SP	176.929
3509403	Cajuru	SP	660.088
3509452	Campina do Monte Alegre	SP	184.479
3509502	Campinas	SP	794.571
3509601	Campo Limpo Paulista	SP	79.403
3509957	Canas	SP	53.261
3510104	Cândido Rodrigues	SP	70.892
3556958	Vitória Brasil	SP	49.832
3557006	Votorantim	SP	184.186
3557105	Votuporanga	SP	420.703
3557154	Zacarias	SP	319.056
3557204	Chavantes	SP	188.727
3510153	Canitar	SP	57.459
3510203	Capão Bonito	SP	1640.229
3510302	Capela do Alto	SP	169.89
3510401	Capivari	SP	322.878
3510500	Caraguatatuba	SP	484.947
3510609	Carapicuíba	SP	34.546
3510708	Cardoso	SP	639.248
3510807	Casa Branca	SP	864.225
3510906	Cássia dos Coqueiros	SP	191.683
3511003	Castilho	SP	1065.318
3511102	Catanduva	SP	290.596
3511201	Catiguá	SP	148.393
3511300	Cedral	SP	197.838
3511409	Cerqueira César	SP	511.621
3511508	Cerquilho	SP	127.803
3511607	Cesário Lange	SP	190.392
3511706	Charqueada	SP	175.846
3511904	Clementina	SP	168.59
3512001	Colina	SP	422.303
3512100	Colômbia	SP	728.648
3512209	Conchal	SP	182.793
3512308	Conchas	SP	466.12
3512407	Cordeirópolis	SP	137.579
3512506	Coroados	SP	246.825
3512605	Coronel Macedo	SP	303.83
3512704	Corumbataí	SP	278.622
3512803	Cosmópolis	SP	154.665
3512902	Cosmorama	SP	441.68
3513009	Cotia	SP	323.994
3513108	Cravinhos	SP	311.423
3513207	Cristais Paulista	SP	385.23
3513306	Cruzália	SP	149.33
3513405	Cruzeiro	SP	305.699
3513504	Cubatão	SP	142.879
3513603	Cunha	SP	1407.25
3513702	Descalvado	SP	753.706
3513801	Diadema	SP	30.732
3513850	Dirce Reis	SP	88.133
3513900	Divinolândia	SP	223.749
3514007	Dobrada	SP	149.729
3514106	Dois Córregos	SP	632.972
3514205	Dolcinópolis	SP	77.939
3514304	Dourado	SP	205.874
3514403	Dracena	SP	487.688
3514502	Duartina	SP	264.557
3514601	Dumont	SP	111.376
3514700	Echaporã	SP	515.258
3514809	Eldorado	SP	1654.256
3514908	Elias Fausto	SP	202.36
3514924	Elisiário	SP	93.98
3514957	Embaúba	SP	83.129
3515004	Embu das Artes	SP	70.398
3515103	Embu-Guaçu	SP	155.641
3515129	Emilianópolis	SP	225.167
3515152	Engenheiro Coelho	SP	109.941
3515186	Espírito Santo do Pinhal	SP	389.235
3515194	Espírito Santo do Turvo	SP	193.666
3515202	Estrela d'Oeste	SP	296.281
3515350	Euclides da Cunha Paulista	SP	573.894
3515400	Fartura	SP	429.171
3515509	Fernandópolis	SP	549.797
3515608	Fernando Prestes	SP	169.99
3515657	Fernão	SP	100.504
3516101	Florínea	SP	225.886
3516200	Franca	SP	605.679
3516309	Francisco Morato	SP	49.001
3516408	Franco da Rocha	SP	132.775
3516507	Gabriel Monteiro	SP	138.681
3518008	Guarani d'Oeste	SP	85.7
3518107	Guarantã	SP	461.746
3518206	Guararapes	SP	955.637
3518305	Guararema	SP	270.816
3518404	Guaratinguetá	SP	752.636
3518503	Guareí	SP	567.884
3518602	Guariba	SP	270.289
3518701	Guarujá	SP	144.794
3519055	Holambra	SP	65.577
3519071	Hortolândia	SP	62.416
3519105	Iacanga	SP	547.393
3519204	Iacri	SP	321.948
3519253	Iaras	SP	401.381
3519303	Ibaté	SP	290.978
3519402	Ibirá	SP	271.912
3519501	Ibirarema	SP	228.23
3520707	Indiaporã	SP	279.606
3520905	Ipaussu	SP	209.554
3521002	Iperó	SP	170.289
3521101	Ipeúna	SP	190.01
3521150	Ipiguá	SP	136.028
3521200	Iporanga	SP	1152.059
3521309	Ipuã	SP	466.461
3521408	Iracemápolis	SP	115.118
3521507	Irapuã	SP	257.612
3521606	Irapuru	SP	214.461
3521705	Itaberá	SP	1100.247
3521804	Itaí	SP	1092.884
3521903	Itajobi	SP	502.066
3522000	Itaju	SP	230.355
3522109	Itanhaém	SP	601.711
3522158	Itaoca	SP	183.015
3522208	Itapecerica da Serra	SP	150.742
3522307	Itapetininga	SP	1789.35
3522406	Itapeva	SP	1826.258
3522505	Itapevi	SP	82.658
3522901	Itapuí	SP	140.023
3523008	Itapura	SP	301.653
3523107	Itaquaquecetuba	SP	82.622
3523206	Itararé	SP	1003.86
3523305	Itariri	SP	273.667
3523404	Itatiba	SP	322.269
3523503	Itatinga	SP	979.817
3523602	Itirapina	SP	564.603
3523701	Itirapuã	SP	161.118
3523800	Itobi	SP	138.986
3523909	Itu	SP	640.719
3524006	Itupeva	SP	200.876
3524105	Ituverava	SP	704.659
3524204	Jaborandi	SP	273.438
3524303	Jaboticabal	SP	706.602
3524402	Jacareí	SP	464.272
3524501	Jaci	SP	145.133
3524600	Jacupiranga	SP	704.189
3524709	Jaguariúna	SP	141.391
3524808	Jales	SP	368.574
3524907	Jambeiro	SP	184.413
3525854	Jumirim	SP	56.685
3525904	Jundiaí	SP	431.204
3526001	Junqueirópolis	SP	582.565
3526100	Juquiá	SP	812.799
3526209	Juquitiba	SP	522.169
3526308	Lagoinha	SP	255.472
3526407	Laranjal Paulista	SP	384.274
3526506	Lavínia	SP	537.675
3526605	Lavrinhas	SP	167.067
3526704	Leme	SP	402.871
3526803	Lençóis Paulista	SP	809.541
3526902	Limeira	SP	580.711
3527009	Lindóia	SP	48.756
3527108	Lins	SP	570.058
3527207	Lorena	SP	414.16
3528858	Marapoama	SP	111.267
3528908	Mariápolis	SP	186.544
3529005	Marília	SP	1170.515
3529104	Marinópolis	SP	77.827
3529203	Martinópolis	SP	1253.564
3529302	Matão	SP	524.899
3529401	Mauá	SP	61.937
3529500	Mendonça	SP	195.151
3529609	Meridiano	SP	228.199
3529658	Mesópolis	SP	148.636
3529708	Miguelópolis	SP	820.849
3529807	Mineiros do Tietê	SP	213.242
3529906	Miracatu	SP	1001.484
3530003	Mira Estrela	SP	216.825
3530102	Mirandópolis	SP	917.694
3530201	Mirante do Paranapanema	SP	1238.931
3530300	Mirassol	SP	243.228
3530409	Mirassolândia	SP	166.125
3530508	Mococa	SP	855.156
3530607	Mogi das Cruzes	SP	712.541
3530706	Mogi Guaçu	SP	812.753
3530904	Mombuca	SP	133.698
3531001	Monções	SP	104.352
3532843	Nova Canaã Paulista	SP	124.473
3532868	Nova Castilho	SP	183.396
3532900	Nova Europa	SP	160.25
3533007	Nova Granada	SP	531.796
3533304	Nova Luzitânia	SP	73.816
3533403	Nova Odessa	SP	73.788
3533502	Novo Horizonte	SP	931.743
3533601	Nuporanga	SP	348.265
3533700	Ocauçu	SP	301.036
3533809	Óleo	SP	198.938
3533908	Olímpia	SP	802.555
3534005	Onda Verde	SP	242.946
3534104	Oriente	SP	218.668
3534203	Orindiúva	SP	247.378
3534302	Orlândia	SP	291.765
3534401	Osasco	SP	64.954
3534500	Oscar Bressane	SP	222.13
3534609	Osvaldo Cruz	SP	248.038
3534708	Ourinhos	SP	295.818
3534757	Ouroeste	SP	288.648
3534807	Ouro Verde	SP	266.778
3534906	Pacaembu	SP	339.375
3535002	Palestina	SP	697.701
3535101	Palmares Paulista	SP	82.125
3535200	Palmeira d'Oeste	SP	318.74
3535309	Palmital	SP	548.407
3535408	Panorama	SP	356.05
3535507	Paraguaçu Paulista	SP	1001.492
3535606	Paraibuna	SP	809.576
3536257	Parisi	SP	84.737
3536307	Patrocínio Paulista	SP	602.848
3536406	Paulicéia	SP	374.091
3536505	Paulínia	SP	138.777
3536570	Paulistânia	SP	256.178
3536604	Paulo de Faria	SP	737.986
3536703	Pederneiras	SP	727.482
3536802	Pedra Bela	SP	158.587
3536901	Pedranópolis	SP	260.101
3537008	Pedregulho	SP	712.604
3537107	Pedreira	SP	108.817
3537156	Pedrinhas Paulista	SP	152.309
3537206	Pedro de Toledo	SP	670.44
3537305	Penápolis	SP	711.315
3537404	Pereira Barreto	SP	974.247
3537503	Pereiras	SP	223.136
3537602	Peruíbe	SP	326.216
3537701	Piacatu	SP	232.488
3537800	Piedade	SP	746.868
3537909	Pilar do Sul	SP	681.248
3538006	Pindamonhangaba	SP	731.355
3538105	Pindorama	SP	184.825
3538204	Pinhalzinho	SP	154.529
3538303	Piquerobi	SP	482.769
3538501	Piquete	SP	175.996
3538600	Piracaia	SP	385.568
3538709	Piracicaba	SP	1378.069
3538808	Piraju	SP	504.591
3539905	Poloni	SP	135.12
3540002	Pompéia	SP	784.674
3540101	Pongaí	SP	183.399
3540200	Pontal	SP	356.371
3540259	Pontalinda	SP	209.525
3540309	Pontes Gestal	SP	217.505
3540408	Populina	SP	315.938
3540507	Porangaba	SP	265.689
3540606	Porto Feliz	SP	556.706
3540705	Porto Ferreira	SP	244.906
3540754	Potim	SP	44.643
3540804	Potirendaba	SP	342.492
3540853	Pracinha	SP	63.054
3540903	Pradópolis	SP	167.378
3541000	Praia Grande	SP	149.652
3541059	Pratânia	SP	175.1
3541109	Presidente Alves	SP	286.642
3541208	Presidente Bernardes	SP	749.233
3541307	Presidente Epitácio	SP	1260.281
3541406	Presidente Prudente	SP	560.637
3541505	Presidente Venceslau	SP	755.203
3541604	Promissão	SP	779.2
3541653	Quadra	SP	205.672
3541703	Quatá	SP	651.341
3541802	Queiroz	SP	234.914
3543204	Ribeirão do Sul	SP	203.208
3543238	Ribeirão dos Índios	SP	196.446
3543253	Ribeirão Grande	SP	333.363
3543303	Ribeirão Pires	SP	98.972
3543402	Ribeirão Preto	SP	650.916
3543501	Riversul	SP	385.878
3543600	Rifaina	SP	162.508
3543709	Rincão	SP	316.639
3543808	Rinópolis	SP	358.481
3543907	Rio Claro	SP	498.422
3544004	Rio das Pedras	SP	226.657
3544251	Rosana	SP	744.011
3544301	Roseira	SP	129.847
3544400	Rubiácea	SP	236.484
3544509	Rubinéia	SP	242.877
3544608	Sabino	SP	305.285
3544707	Sagres	SP	147.935
3544806	Sales	SP	308.555
3544905	Sales Oliveira	SP	305.776
3545001	Salesópolis	SP	424.997
3545100	Salmourão	SP	172.934
3545159	Saltinho	SP	99.738
3545209	Salto	SP	133.057
3545308	Salto de Pirapora	SP	280.412
3545407	Salto Grande	SP	188.441
3545506	Sandovalina	SP	455.856
3545605	Santa Adélia	SP	330.269
3545704	Santa Albertina	SP	272.692
3545803	Santa Bárbara d'Oeste	SP	271.03
3546009	Santa Branca	SP	272.238
3546108	Santa Clara d'Oeste	SP	183.458
3557303	Estiva Gerbi	SP	74.144
4100103	Abatiá	PR	228.717
4100202	Adrianópolis	PR	1349.311
4100301	Agudos do Sul	PR	192.261
4100400	Almirante Tamandaré	PR	194.228
4100459	Altamira do Paraná	PR	386.945
3546207	Santa Cruz da Conceição	SP	150.13
3546256	Santa Cruz da Esperança	SP	148.062
3546306	Santa Cruz das Palmeiras	SP	295.337
3546504	Santa Ernestina	SP	134.421
3546603	Santa Fé do Sul	SP	206.537
4103024	Boa Esperança do Iguaçu	PR	151.797
4103040	Boa Ventura de São Roque	PR	620.453
3546702	Santa Gertrudes	SP	98.291
3546801	Santa Isabel	SP	363.332
4103370	Brasilândia do Sul	PR	291.036
3546900	Santa Lúcia	SP	153.86
3547007	Santa Maria da Serra	SP	252.621
3547106	Santa Mercedes	SP	166.753
3547205	Santana da Ponte Pensa	SP	129.888
3547304	Santana de Parnaíba	SP	179.949
4103404	Cafeara	PR	185.8
4103453	Cafelândia	PR	274.904
4103479	Cafezal do Sul	PR	335.392
4103503	Califórnia	PR	141.817
3547403	Santa Rita d'Oeste	SP	209.8
3547502	Santa Rita do Passa Quatro	SP	754.141
3547601	Santa Rosa de Viterbo	SP	288.576
3547650	Santa Salete	SP	79.192
3547700	Santo Anastácio	SP	552.876
3547809	Santo André	SP	175.782
3547908	Santo Antônio da Alegria	SP	310.311
3548005	Santo Antônio de Posse	SP	154.133
3548054	Santo Antônio do Aracanguá	SP	1308.432
4107108	Diamante do Norte	PR	242.887
4107124	Diamante do Sul	PR	347.233
3548104	Santo Antônio do Jardim	SP	109.956
4108106	Flórida	PR	83.046
4108205	Formosa do Oeste	PR	275.901
4108304	Foz do Iguaçu	PR	609.192
3548203	Santo Antônio do Pinhal	SP	133.008
3548302	Santo Expedito	SP	94.465
3548401	Santópolis do Aguapeí	SP	128.026
3548500	Santos	SP	281.033
3548609	São Bento do Sapucaí	SP	252.579
3548708	São Bernardo do Campo	SP	409.532
3548807	São Caetano do Sul	SP	15.331
3549003	São Francisco	SP	75.579
3549102	São João da Boa Vista	SP	516.399
3549201	São João das Duas Pontes	SP	129.462
3549250	São João de Iracema	SP	178.396
3549300	São João do Pau d'Alho	SP	117.665
3549409	São Joaquim da Barra	SP	410.863
3549508	São José da Bela Vista	SP	276.952
3549607	São José do Barreiro	SP	570.685
3549706	São José do Rio Pardo	SP	419.684
3549805	São José do Rio Preto	SP	431.944
3549904	São José dos Campos	SP	1099.409
3549953	São Lourenço da Serra	SP	186.456
3550001	São Luiz do Paraitinga	SP	617.315
3550100	São Manuel	SP	650.734
3550209	São Miguel Arcanjo	SP	930.339
3550308	São Paulo	SP	1521.202
3550407	São Pedro	SP	611.278
3550506	São Pedro do Turvo	SP	731.221
3550605	São Roque	SP	306.908
3550704	São Sebastião	SP	402.395
3550803	São Sebastião da Grama	SP	252.41
3550902	São Simão	SP	617.252
3551009	São Vicente	SP	148.151
3551108	Sarapuí	SP	352.592
3551207	Sarutaiá	SP	141.608
3551900	Severínia	SP	140.46
3552007	Silveiras	SP	414.782
3552106	Socorro	SP	449.029
3552205	Sorocaba	SP	449.872
3552304	Sud Mennucci	SP	594.744
3552403	Sumaré	SP	153.465
3552502	Suzano	SP	206.236
3552551	Suzanápolis	SP	330.587
3552601	Tabapuã	SP	345.792
3552700	Tabatinga	SP	368.604
3552809	Taboão da Serra	SP	20.388
3552908	Taciba	SP	607.267
3553005	Taguaí	SP	145.332
3553104	Taiaçu	SP	107.059
3553203	Taiúva	SP	132.459
3553302	Tambaú	SP	561.788
3553658	Taquaral	SP	53.892
3553708	Taquaritinga	SP	594.335
3553807	Taquarituba	SP	448.515
3553856	Taquarivaí	SP	231.792
3553906	Tarabai	SP	201.385
3553955	Tarumã	SP	302.913
3554003	Tatuí	SP	523.749
3554102	Taubaté	SP	625.003
3554201	Tejupá	SP	296.189
3554300	Teodoro Sampaio	SP	1555.803
3554409	Terra Roxa	SP	221.541
3554508	Tietê	SP	404.396
3554607	Timburi	SP	196.79
3554656	Torre de Pedra	SP	71.348
3554706	Torrinha	SP	315.267
3554755	Trabiju	SP	63.421
3554805	Tremembé	SP	191.094
3554904	Três Fronteiras	SP	151.594
3554953	Tuiuti	SP	126.731
3555000	Tupã	SP	627.986
3555109	Tupi Paulista	SP	244.77
3555208	Turiúba	SP	153.235
3555703	União Paulista	SP	79.056
3555802	Urânia	SP	209.262
3555901	Uru	SP	146.901
3556008	Urupês	SP	323.916
3556107	Valentim Gentil	SP	149.741
3556206	Valinhos	SP	148.538
3556305	Valparaíso	SP	857.661
3556354	Vargem	SP	142.595
3556404	Vargem Grande do Sul	SP	267.178
3556453	Vargem Grande Paulista	SP	42.489
3556503	Várzea Paulista	SP	35.12
3556602	Vera Cruz	SP	247.716
3556701	Vinhedo	SP	80.95
3556800	Viradouro	SP	217.726
4108809	Guaíra	PR	563.742
3556909	Vista Alegre do Alto	SP	95.429
4100509	Altônia	PR	661.56
4121307	Rancho Alegre	PR	167.646
4121356	Rancho Alegre D'Oeste	PR	241.386
4121406	Realeza	PR	353.416
4121505	Rebouças	PR	481.84
4121604	Renascença	PR	425.273
4121703	Reserva	PR	1635.535
4100608	Alto Paraná	PR	407.719
4121752	Reserva do Iguaçu	PR	834.232
4100707	Alto Piquiri	PR	447.666
4121802	Ribeirão Claro	PR	629.224
4121901	Ribeirão do Pinhal	PR	374.732
4122008	Rio Azul	PR	599.056
4122107	Rio Bom	PR	177.836
4122156	Rio Bonito do Iguaçu	PR	681.406
4122172	Rio Branco do Ivaí	PR	376.109
4122206	Rio Branco do Sul	PR	811.425
4122305	Rio Negro	PR	604.138
4122404	Rolândia	PR	459.024
4122503	Roncador	PR	742.121
4100806	Alvorada do Sul	PR	424.25
4100905	Amaporã	PR	384.735
4101002	Ampére	PR	298.349
4101051	Anahy	PR	102.895
4101101	Andirá	PR	235.944
4101150	Ângulo	PR	106.021
4101200	Antonina	PR	891.582
4101309	Antônio Olinto	PR	469.62
4101408	Apucarana	PR	556.99
4101507	Arapongas	PR	382.215
4101606	Arapoti	PR	1358.176
4101655	Arapuã	PR	217.371
4101705	Araruna	PR	493.191
4101804	Araucária	PR	469.24
4101853	Ariranha do Ivaí	PR	234.076
4101903	Assaí	PR	440.347
4102000	Assis Chateaubriand	PR	980.727
4102109	Astorga	PR	434.792
4102208	Atalaia	PR	137.663
4102307	Balsa Nova	PR	348.926
4102406	Bandeirantes	PR	445.192
4102505	Barbosa Ferraz	PR	538.636
4102604	Barracão	PR	161.213
4102703	Barra do Jacaré	PR	115.855
4102752	Bela Vista da Caroba	PR	148.107
4124053	Santa Terezinha de Itaipu	PR	268.258
4102802	Bela Vista do Paraíso	PR	242.689
4102901	Bituruna	PR	1234.946
4103008	Boa Esperança	PR	302.739
4103057	Boa Vista da Aparecida	PR	266.175
4103107	Bocaiúva do Sul	PR	825.665
4124103	Santo Antônio da Platina	PR	721.472
4103156	Bom Jesus do Sul	PR	176.129
4103206	Bom Sucesso	PR	322.755
4103222	Bom Sucesso do Sul	PR	195.931
4103305	Borrazópolis	PR	334.378
4103354	Braganey	PR	343.321
4103602	Cambará	PR	366.153
4103701	Cambé	PR	495.375
4103800	Cambira	PR	164.786
4103909	Campina da Lagoa	PR	796.614
4103958	Campina do Simão	PR	448.424
4104006	Campina Grande do Sul	PR	539.245
4104055	Campo Bonito	PR	433.832
4104105	Campo do Tenente	PR	304.488
4104204	Campo Largo	PR	1243.551
4104253	Campo Magro	PR	275.352
4104303	Campo Mourão	PR	749.637
4104402	Cândido de Abreu	PR	1510.16
4104428	Candói	PR	1512.786
4104451	Cantagalo	PR	583.304
4104501	Capanema	PR	419.036
4104600	Capitão Leônidas Marques	PR	280.063
4104659	Carambeí	PR	649.68
4124202	Santo Antônio do Caiuá	PR	219.068
4124301	Santo Antônio do Paraíso	PR	167.014
4124400	Santo Antônio do Sudoeste	PR	325.651
4104709	Carlópolis	PR	451.418
4104808	Cascavel	PR	2091.199
4104907	Castro	PR	2531.503
4105003	Catanduvas	PR	580.421
4105102	Centenário do Sul	PR	371.834
4105201	Cerro Azul	PR	1341.189
4105300	Céu Azul	PR	1179.449
4105409	Chopinzinho	PR	959.692
4105508	Cianorte	PR	811.666
4105607	Cidade Gaúcha	PR	403.045
4105706	Clevelândia	PR	703.638
4105805	Colombo	PR	197.58
4105904	Colorado	PR	407.568
4106001	Congonhinhas	PR	535.963
4106100	Conselheiro Mairinck	PR	204.705
4106209	Contenda	PR	299.037
4106308	Corbélia	PR	529.137
4106407	Cornélio Procópio	PR	635.1
4106456	Coronel Domingos Soares	PR	1556.186
4106506	Coronel Vivida	PR	684.417
4124509	Santo Inácio	PR	280.133
4106555	Corumbataí do Sul	PR	164.341
4106571	Cruzeiro do Iguaçu	PR	161.862
4106605	Cruzeiro do Oeste	PR	775.984
4106704	Cruzeiro do Sul	PR	259.103
4106803	Cruz Machado	PR	1478.35
4106852	Cruzmaltina	PR	312.299
4106902	Curitiba	PR	434.892
4107009	Curiúva	PR	576.263
4107157	Diamante D'Oeste	PR	309.11
4107207	Dois Vizinhos	PR	418.648
4107256	Douradina	PR	420.604
4107306	Doutor Camargo	PR	118.279
4107405	Enéas Marques	PR	192.203
4107504	Engenheiro Beltrão	PR	467.47
4107520	Esperança Nova	PR	141.286
4107538	Entre Rios do Oeste	PR	120.967
4107546	Espigão Alto do Iguaçu	PR	326.44
4107553	Farol	PR	289.232
4107603	Faxinal	PR	715.943
4107652	Fazenda Rio Grande	PR	116.678
4124608	São Carlos do Ivaí	PR	225.079
4124707	São Jerônimo da Serra	PR	823.774
4124806	São João	PR	388.059
4107702	Fênix	PR	234.099
4107736	Fernandes Pinheiro	PR	406.5
4107751	Figueira	PR	129.769
4107801	Floraí	PR	191.133
4107850	Flor da Serra do Sul	PR	255.721
4107900	Floresta	PR	158.226
4108007	Florestópolis	PR	246.853
4108320	Francisco Alves	PR	321.898
4108403	Francisco Beltrão	PR	735.111
4108452	Foz do Jordão	PR	235.382
4108502	General Carneiro	PR	1071.183
4125902	São Pedro do Paraná	PR	250.654
4108551	Godoy Moreira	PR	131.012
4108601	Goioerê	PR	564.163
4108650	Goioxim	PR	702.471
4108700	Grandes Rios	PR	314.198
4108908	Guairaçá	PR	493.94
4108957	Guamiranga	PR	244.795
4109005	Guapirama	PR	189.1
4109757	Ibema	PR	145.446
4109807	Ibiporã	PR	297.742
4109104	Guaporema	PR	201.15
4110300	Inajá	PR	194.704
4109203	Guaraci	PR	211.68
4109302	Guaraniaçu	PR	1238.32
4109401	Guarapuava	PR	3168.087
4109500	Guaraqueçaba	PR	2011.357
4109609	Guaratuba	PR	1326.67
4109658	Honório Serpa	PR	502.235
4109708	Ibaiti	PR	898.221
4109906	Icaraíma	PR	675.24
4110003	Iguaraçu	PR	164.983
4110052	Iguatu	PR	106.937
4110078	Imbaú	PR	330.734
4110102	Imbituva	PR	756.535
4110201	Inácio Martins	PR	936.208
4110409	Indianópolis	PR	122.622
4110508	Ipiranga	PR	900.721
4110607	Iporã	PR	647.894
4111308	Itaúna do Sul	PR	128.87
4111407	Ivaí	PR	607.848
4111506	Ivaiporã	PR	436.989
4111555	Ivaté	PR	410.156
4110656	Iracema do Oeste	PR	81.538
4110706	Irati	PR	999.517
4110805	Iretama	PR	570.459
4113700	Londrina	PR	1652.569
4113734	Luiziana	PR	916.839
4126652	Sulina	PR	170.759
4126678	Tamarana	PR	472.155
4110904	Itaguajé	PR	194.353
4110953	Itaipulândia	PR	330.846
4111001	Itambaracá	PR	207.342
4111100	Itambé	PR	243.822
4111209	Itapejara d'Oeste	PR	254.014
4111258	Itaperuçu	PR	322.991
4126702	Tamboara	PR	193.346
4126801	Tapejara	PR	591.399
4111605	Ivatuba	PR	96.661
4111704	Jaboti	PR	139.277
4111803	Jacarezinho	PR	602.528
4111902	Jaguapitã	PR	475.004
4112009	Jaguariaíva	PR	1453.066
4112108	Jandaia do Sul	PR	187.6
4112207	Janiópolis	PR	335.65
4112306	Japira	PR	187.802
4126900	Tapira	PR	434.371
4127007	Teixeira Soares	PR	902.793
4127106	Telêmaco Borba	PR	1382.86
4112405	Japurá	PR	165.185
4112504	Jardim Alegre	PR	413.386
4112603	Jardim Olinda	PR	128.515
4127205	Terra Boa	PR	320.85
4112702	Jataizinho	PR	159.178
4112751	Jesuítas	PR	247.496
4112801	Joaquim Távora	PR	289.173
4112900	Jundiaí do Sul	PR	320.816
4112959	Juranda	PR	354.364
4303558	Camargo	RS	138.069
4303608	Cambará do Sul	RS	1181.811
4303673	Campestre da Serra	RS	538.487
4303707	Campina das Missões	RS	224.801
4113007	Jussara	PR	210.869
4304200	Candelária	RS	944.735
4304309	Cândido Godói	RS	247.047
4304358	Candiota	RS	933.628
4304408	Canela	RS	253.002
4304507	Canguçu	RS	3526.253
4312450	Morro Redondo	RS	244.645
4312476	Morro Reuter	RS	89.412
4113106	Kaloré	PR	193.299
4113205	Lapa	PR	2093.859
4113254	Laranjal	PR	559.439
4113304	Laranjeiras do Sul	PR	673.688
4113403	Leópolis	PR	344.918
4113429	Lidianópolis	PR	151.456
4113452	Lindoeste	PR	347.093
4114708	Maria Helena	PR	486.224
4113502	Loanda	PR	722.496
4114807	Marialva	PR	475.564
4114906	Marilândia do Sul	PR	384.424
4115002	Marilena	PR	232.363
4115101	Mariluz	PR	433.17
4115200	Maringá	PR	487.012
4113601	Lobato	PR	240.904
4113759	Lunardelli	PR	199.213
4113809	Lupionópolis	PR	121.066
4113908	Mallet	PR	760.224
4114005	Mamborê	PR	788.061
4114104	Mandaguaçu	PR	294.019
4114203	Mandaguari	PR	335.814
4114302	Mandirituba	PR	379.179
4114351	Manfrinópolis	PR	215.779
4114401	Mangueirinha	PR	1055.458
4114500	Manoel Ribas	PR	571.135
4114609	Marechal Cândido Rondon	PR	745.748
4115309	Mariópolis	PR	230.365
4115358	Maripá	PR	283.793
4115408	Marmeleiro	PR	387.612
4115457	Marquinho	PR	503.858
4115507	Marumbi	PR	208.47
4115606	Matelândia	PR	639.746
4115705	Matinhos	PR	117.899
4115739	Mato Rico	PR	394.533
4115754	Mauá da Serra	PR	108.324
4115804	Medianeira	PR	328.732
4115853	Mercedes	PR	197.136
4312609	Muçum	RS	111.247
4115903	Mirador	PR	221.708
4312617	Muitos Capões	RS	1193.23
4116000	Miraselva	PR	90.294
4116059	Missal	PR	324.397
4117206	Nova Olímpia	PR	136.347
4116109	Moreira Sales	PR	353.772
4116208	Morretes	PR	684.58
4116307	Munhoz de Melo	PR	137.018
4118451	Pato Bragado	PR	135.6
4118501	Pato Branco	PR	539.087
4118600	Paula Freitas	PR	421.409
4118709	Paulo Frontin	PR	363.351
4118808	Peabiru	PR	468.594
4116406	Nossa Senhora das Graças	PR	185.769
4118857	Perobal	PR	409.05
4118907	Pérola	PR	236.186
4119004	Pérola d'Oeste	PR	205.279
4119103	Piên	PR	254.792
4119152	Pinhais	PR	60.869
4119202	Pinhalão	PR	220.625
4312625	Muliterno	RS	111.132
4116505	Nova Aliança do Ivaí	PR	131.272
4116604	Nova América da Colina	PR	129.476
4116703	Nova Aurora	PR	470.642
4116802	Nova Cantu	PR	555.488
4116901	Nova Esperança	PR	401.587
4116950	Nova Esperança do Sudoeste	PR	208.472
4117008	Nova Fátima	PR	283.423
4117057	Nova Laranjeiras	PR	1210.205
4117107	Nova Londrina	PR	269.389
4119608	Pitanga	PR	1663.747
4313334	Nova Ramada	RS	255.264
4313359	Nova Roma do Sul	RS	149.767
4117214	Nova Santa Bárbara	PR	76.887
4117222	Nova Santa Rosa	PR	204.665
4117255	Nova Prata do Iguaçu	PR	352.565
4117271	Nova Tebas	PR	545.686
4117297	Novo Itacolomi	PR	161.411
4117305	Ortigueira	PR	2429.52
4117404	Ourizona	PR	176.457
4117453	Ouro Verde do Oeste	PR	293.042
4119806	Planalto	PR	346.241
4119905	Ponta Grossa	PR	2054.732
4119954	Pontal do Paraná	PR	200.41
4117503	Paiçandu	PR	171.379
4117602	Palmas	PR	1557.903
4117701	Palmeira	PR	1470.072
4117800	Palmital	PR	817.647
4117909	Palotina	PR	651.238
4118006	Paraíso do Norte	PR	204.564
4118105	Paranacity	PR	348.631
4118204	Paranaguá	PR	822.838
4118303	Paranapoema	PR	175.875
4118402	Paranavaí	PR	1202.266
4119251	Pinhal de São Bento	PR	97.463
4119301	Pinhão	PR	2001.588
4119400	Piraí do Sul	PR	1345.417
4119509	Piraquara	PR	227.042
4119657	Pitangueiras	PR	123.229
4310363	Imigrante	RS	71.716
4310405	Independência	RS	358.283
4310413	Inhacorá	RS	113.749
4310439	Ipê	RS	599.032
4119707	Planaltina do Paraná	PR	356.192
4120002	Porecatu	PR	291.663
4120101	Porto Amazonas	PR	186.581
4120150	Porto Barreiro	PR	361.02
4120200	Porto Rico	PR	217.676
4310462	Ipiranga do Sul	RS	158.71
4310504	Iraí	RS	181.579
4120309	Porto Vitória	PR	213.013
4120333	Prado Ferreira	PR	152.876
4120358	Pranchita	PR	226.14
4120408	Presidente Castelo Branco	PR	155.734
4121000	Querência do Norte	PR	914.763
4120507	Primeiro de Maio	PR	414.442
4120606	Prudentópolis	PR	2247.141
4120655	Quarto Centenário	PR	321.875
4120705	Quatiguá	PR	112.689
4121257	Ramilândia	PR	237.196
4120804	Quatro Barras	PR	180.471
4120853	Quatro Pontes	PR	114.393
4120903	Quedas do Iguaçu	PR	821.503
4121109	Quinta do Sol	PR	326.177
4121208	Quitandinha	PR	447.024
4122602	Rondon	PR	555.125
4122651	Rosário do Ivaí	PR	377.47
4122701	Sabáudia	PR	190.329
4122800	Salgado Filho	PR	181.015
4310801	Ivoti	RS	63.092
4310850	Jaboticaba	RS	127.589
4310876	Jacuizinho	RS	339.399
4310900	Jacutinga	RS	178.009
4122909	Salto do Itararé	PR	200.52
4123006	Salto do Lontra	PR	312.717
4311007	Jaguarão	RS	2051.845
4311106	Jaguari	RS	675.314
4311122	Jaquirana	RS	908.879
4123105	Santa Amélia	PR	78.045
4123204	Santa Cecília do Pavão	PR	105.076
4123303	Santa Cruz de Monte Castelo	PR	442.013
4313441	Novo Tiradentes	RS	75.428
4123402	Santa Fé	PR	276.241
4313466	Novo Xingu	RS	79.851
4313490	Novo Barreiro	RS	123.344
4313508	Osório	RS	663.878
4313607	Paim Filho	RS	182.115
4313656	Palmares do Sul	RS	949.201
4313706	Palmeira das Missões	RS	1421.101
4313805	Palmitinho	RS	144.181
4313904	Panambi	RS	491.57
4123501	Santa Helena	PR	754.701
4123600	Santa Inês	PR	156.935
4314076	Passo do Sobrado	RS	265.133
4123709	Santa Isabel do Ivaí	PR	349.497
4123808	Santa Izabel do Oeste	PR	321.182
4314100	Passo Fundo	RS	784.407
4314134	Paulo Bento	RS	149.669
4123824	Santa Lúcia	PR	126.813
4123857	Santa Maria do Oeste	PR	836.669
4123907	Santa Mariana	PR	427.193
4311643	Linha Nova	RS	63.502
4311700	Machadinho	RS	335.198
4123956	Santa Mônica	PR	259.957
4311759	Manoel Viana	RS	1390.696
4311775	Maquiné	RS	613.58
4311791	Maratá	RS	82.063
4311809	Marau	RS	649.77
4124004	Santana do Itararé	PR	251.269
4124020	Santa Tereza do Oeste	PR	326.19
4314159	Paverama	RS	171.863
4314175	Pedras Altas	RS	1373.985
4314209	Pedro Osório	RS	603.757
4314308	Pejuçara	RS	414.106
4124905	São João do Caiuá	PR	304.413
4127403	Terra Roxa	PR	800.807
4125001	São João do Ivaí	PR	353.331
4125100	São João do Triunfo	PR	720.407
4125209	São Jorge d'Oeste	PR	379.545
4125308	São Jorge do Ivaí	PR	315.088
4127502	Tibagi	PR	2977.933
4127601	Tijucas do Sul	PR	671.889
4127700	Toledo	PR	1198.049
4127809	Tomazina	PR	591.438
4127858	Três Barras do Paraná	PR	505.505
4127882	Tunas do Paraná	PR	668.478
4127908	Tuneiras do Oeste	PR	698.871
4314407	Pelotas	RS	1608.78
4125357	São Jorge do Patrocínio	PR	406.413
4128534	Ventania	PR	819.334
4125407	São José da Boa Vista	PR	399.667
4125456	São José das Palmeiras	PR	182.419
4125506	São José dos Pinhais	PR	946.435
4125555	São Manoel do Paraná	PR	95.381
4125605	São Mateus do Sul	PR	1341.714
4125704	São Miguel do Iguaçu	PR	851.917
4125753	São Pedro do Iguaçu	PR	308.324
4201208	Antônio Carlos	SC	234.422
4201257	Apiúna	SC	493.49
4125803	São Pedro do Ivaí	PR	322.692
4126009	São Sebastião da Amoreira	PR	226.872
4201273	Arabutã	SC	132.779
4201307	Araquari	SC	386.693
4201406	Araranguá	SC	301.819
4126108	São Tomé	PR	218.623
4126207	Sapopema	PR	677.609
4126256	Sarandi	PR	103.501
4201505	Armazém	SC	173.958
4201604	Arroio Trinta	SC	93.53
4201653	Arvoredo	SC	90.503
4201703	Ascurra	SC	112.884
4201802	Atalanta	SC	94.383
4201901	Aurora	SC	207.045
4201950	Balneário Arroio do Silva	SC	94.477
4202008	Balneário Camboriú	SC	45.214
4202057	Balneário Barra do Sul	SC	108.914
4202073	Balneário Gaivota	SC	146.834
4202081	Bandeirante	SC	148.074
4202099	Barra Bonita	SC	92.561
4202107	Barra Velha	SC	138.947
4202131	Bela Vista do Toldo	SC	535.682
4202156	Belmonte	SC	93.852
4202206	Benedito Novo	SC	388.291
4202305	Biguaçu	SC	365.755
4202404	Blumenau	SC	518.619
4202438	Bocaina do Sul	SC	510.673
4202453	Bombinhas	SC	35.143
4202503	Bom Jardim da Serra	SC	938.516
4202537	Bom Jesus	SC	63.883
4202578	Bom Jesus do Oeste	SC	67.777
4202602	Bom Retiro	SC	1057.034
4202701	Botuverá	SC	296.256
4202800	Braço do Norte	SC	212.045
4202859	Braço do Trombudo	SC	89.411
4202875	Brunópolis	SC	336.439
4202909	Brusque	SC	284.675
4203006	Caçador	SC	983.424
4126272	Saudade do Iguaçu	PR	152.084
4126306	Sengés	PR	1441.333
4126355	Serranópolis do Iguaçu	PR	482.394
4203105	Caibi	SC	173.079
4203154	Calmon	SC	636.208
4203204	Camboriú	SC	210.568
4203253	Capão Alto	SC	1331.962
4203303	Campo Alegre	SC	499.216
4203402	Campo Belo do Sul	SC	1025.638
4203501	Campo Erê	SC	479.161
4203600	Campos Novos	SC	1717.697
4203709	Canelinha	SC	151.008
4203808	Canoinhas	SC	1148.036
4203907	Capinzal	SC	244.057
4203956	Capivari de Baixo	SC	53.222
4204004	Catanduvas	SC	199.166
4204103	Caxambu do Sul	SC	140.873
4204152	Celso Ramos	SC	208.391
4204178	Cerro Negro	SC	418.544
4204194	Chapadão do Lageado	SC	124.866
4204202	Chapecó	SC	624.846
4204251	Cocal do Sul	SC	70.965
4204301	Concórdia	SC	799.194
4204350	Cordilheira Alta	SC	83.556
4204400	Coronel Freitas	SC	233.698
4204459	Coronel Martins	SC	107.502
4204509	Corupá	SC	405.761
4204558	Correia Pinto	SC	647.388
4204608	Criciúma	SC	234.865
4204707	Cunha Porã	SC	220.099
4204756	Cunhataí	SC	54.811
4204806	Curitibanos	SC	949.865
4204905	Descanso	SC	287.057
4205001	Dionísio Cerqueira	SC	378.843
4205100	Dona Emma	SC	178.157
4205159	Doutor Pedrinho	SC	374.205
4205175	Entre Rios	SC	103.888
4205191	Ermo	SC	65.311
4205209	Erval Velho	SC	208.841
4126405	Sertaneja	PR	444.492
4205308	Faxinal dos Guedes	SC	340.07
4205357	Flor do Sertão	SC	58.457
4205407	Florianópolis	SC	674.844
4205431	Formosa do Sul	SC	100.408
4205456	Forquilhinha	SC	183.351
4205506	Fraiburgo	SC	549.188
4205555	Frei Rogério	SC	158.775
4205605	Galvão	SC	139.836
4205704	Garopaba	SC	114.773
4205803	Garuva	SC	503.595
4205902	Gaspar	SC	386.616
4206009	Governador Celso Ramos	SC	127.556
4206108	Grão-Pará	SC	334.362
4206207	Gravatal	SC	165.718
4206306	Guabiruba	SC	172.173
4206405	Guaraciaba	SC	331.766
4206504	Guaramirim	SC	267.514
4206603	Guarujá do Sul	SC	100.63
4206652	Guatambú	SC	206.196
4206702	Herval d'Oeste	SC	216.581
4206751	Ibiam	SC	146.009
4206801	Ibicaré	SC	156.439
4206900	Ibirama	SC	247.102
4207007	Içara	SC	230.393
4207106	Ilhota	SC	253.024
4207205	Imaruí	SC	542.238
4207304	Imbituba	SC	181.577
4207403	Imbuia	SC	119.113
4207502	Indaial	SC	430.799
4207577	Iomerê	SC	113.986
4207601	Ipira	SC	155.651
4207650	Iporã do Oeste	SC	200.96
4207684	Ipuaçu	SC	261.081
4207700	Ipumirim	SC	245.921
4207759	Iraceminha	SC	165.147
4207809	Irani	SC	325.862
4126504	Sertanópolis	PR	505.532
4126603	Siqueira Campos	PR	278.035
4207858	Irati	SC	77.912
4207908	Irineópolis	SC	589.698
4208005	Itá	SC	166.265
4208104	Itaiópolis	SC	1297.543
4208203	Itajaí	SC	289.215
4208302	Itapema	SC	58.21
4208401	Itapiranga	SC	281.782
4208450	Itapoá	SC	245.394
4208500	Ituporanga	SC	336.588
4208609	Jaborá	SC	182.483
4208708	Jacinto Machado	SC	430.704
4208807	Jaguaruna	SC	326.362
4208906	Jaraguá do Sul	SC	530.894
4208955	Jardinópolis	SC	68.499
4209003	Joaçaba	SC	241.637
4209102	Joinville	SC	1127.947
4209151	José Boiteux	SC	405.552
4209177	Jupiá	SC	91.448
4209201	Lacerdópolis	SC	69.036
4209300	Lages	SC	2637.66
4209409	Laguna	SC	333.26
4209458	Lajeado Grande	SC	65.348
4209508	Laurentino	SC	79.333
4209607	Lauro Müller	SC	271.852
4209706	Lebon Régis	SC	941.64
4209805	Leoberto Leal	SC	293.6
4209854	Lindóia do Sul	SC	190.171
4209904	Lontras	SC	197.586
4210001	Luiz Alves	SC	260.106
4210035	Luzerna	SC	117.099
4210050	Macieira	SC	261.208
4127304	Terra Rica	PR	700.599
4210100	Mafra	SC	1404.084
4210209	Major Gercino	SC	306.058
4210308	Major Vieira	SC	520.816
4210407	Maracajá	SC	62.902
4210506	Maravilha	SC	170.339
4210555	Marema	SC	104.184
4210605	Massaranduba	SC	374.459
4210704	Matos Costa	SC	435.391
4210803	Meleiro	SC	186.439
4210852	Mirim Doce	SC	337.991
4210902	Modelo	SC	92.346
4211009	Mondaí	SC	200.276
4211058	Monte Carlo	SC	191.278
4211108	Monte Castelo	SC	560.743
4211207	Morro da Fumaça	SC	82.818
4211256	Morro Grande	SC	260.143
4211306	Navegantes	SC	111.377
4211405	Nova Erechim	SC	65.087
4211454	Nova Itaberaba	SC	137.388
4211504	Nova Trento	SC	402.852
4211603	Nova Veneza	SC	295.061
4211652	Novo Horizonte	SC	151.722
4127957	Tupãssi	PR	299.769
4127965	Turvo	PR	938.966
4128005	Ubiratã	PR	652.581
4128104	Umuarama	PR	1234.537
4128203	União da Vitória	PR	719.998
4211702	Orleans	SC	549.859
4211751	Otacílio Costa	SC	847.253
4211801	Ouro	SC	213.543
4211850	Ouro Verde	SC	188.568
4211876	Paial	SC	86.048
4211892	Painel	SC	738.331
4211900	Palhoça	SC	394.85
4212007	Palma Sola	SC	330.878
4212056	Palmeira	SC	289.097
4212106	Palmitos	SC	351.051
4212205	Papanduva	SC	764.737
4212239	Paraíso	SC	180.338
4212254	Passo de Torres	SC	92.638
4212270	Passos Maia	SC	617.092
4212304	Paulo Lopes	SC	446.165
4212403	Pedras Grandes	SC	159.891
4212502	Penha	SC	57.752
4212601	Peritiba	SC	96.168
4212650	Pescaria Brava	SC	106.853
4212700	Petrolândia	SC	306.76
4212809	Balneário Piçarras	SC	99.355
4212908	Pinhalzinho	SC	128.726
4213005	Pinheiro Preto	SC	61.011
4213104	Piratuba	SC	146.088
4213153	Planalto Alegre	SC	63.1
4213203	Pomerode	SC	214.299
4213302	Ponte Alta	SC	575.17
4213351	Ponte Alta do Norte	SC	396.882
4213401	Ponte Serrada	SC	560.731
4213500	Porto Belo	SC	93.673
4213609	Porto União	SC	848.779
4213708	Pouso Redondo	SC	356.539
4128302	Uniflor	PR	94.819
4213807	Praia Grande	SC	284.36
4213906	Presidente Castello Branco	SC	65.433
4214003	Presidente Getúlio	SC	297.16
4214102	Presidente Nereu	SC	224.748
4214151	Princesa	SC	85.598
4214201	Quilombo	SC	278.983
4214300	Rancho Queimado	SC	286.461
4214409	Rio das Antas	SC	314.913
4214508	Rio do Campo	SC	502.095
4214607	Rio do Oeste	SC	245.057
4214706	Rio dos Cedros	SC	555.473
4214805	Rio do Sul	SC	260.817
4214904	Rio Fortuna	SC	302.39
4215000	Rio Negrinho	SC	907.42
4215059	Rio Rufino	SC	282.571
4215075	Riqueza	SC	191.061
4215109	Rodeio	SC	129.001
4215208	Romelândia	SC	223.333
4215307	Salete	SC	177.887
4215356	Saltinho	SC	156.568
4215406	Salto Veloso	SC	104.531
4215455	Sangão	SC	82.984
4215505	Santa Cecília	SC	1145.845
4215554	Santa Helena	SC	81.004
4215604	Santa Rosa de Lima	SC	203.218
4215653	Santa Rosa do Sul	SC	150.299
4215679	Santa Terezinha	SC	715.551
4215687	Santa Terezinha do Progresso	SC	119.653
4128401	Uraí	PR	237.81
4215695	Santiago do Sul	SC	73.335
4215703	Santo Amaro da Imperatriz	SC	344.235
4215752	São Bernardino	SC	149.891
4215802	São Bento do Sul	SC	495.772
4215901	São Bonifácio	SC	461.438
4216008	São Carlos	SC	162.12
4216057	São Cristóvão do Sul	SC	345.903
4216107	São Domingos	SC	367.525
4216206	São Francisco do Sul	SC	493.266
4216255	São João do Oeste	SC	163.747
4128500	Wenceslau Braz	PR	397.916
4128559	Vera Cruz do Oeste	PR	327.09
4128609	Verê	PR	311.801
4128625	Alto Paraíso	PR	967.772
4128633	Doutor Ulysses	PR	777.482
4128658	Virmond	PR	249.094
4128708	Vitorino	PR	308.218
4128807	Xambrê	PR	359.712
4200051	Abdon Batista	SC	237.517
4200101	Abelardo Luz	SC	953.992
4200200	Agrolândia	SC	206.815
4200309	Agronômica	SC	129.774
4200408	Água Doce	SC	1319.137
4200507	Águas de Chapecó	SC	139.511
4200556	Águas Frias	SC	76.631
4200606	Águas Mornas	SC	326.66
4200705	Alfredo Wagner	SC	733.489
4200754	Alto Bela Vista	SC	103.433
4200804	Anchieta	SC	232.348
4200903	Angelina	SC	499.998
4201000	Anita Garibaldi	SC	589.812
4201109	Anitápolis	SC	540.636
4300851	Arambaré	RS	518.193
4300877	Araricá	RS	35.391
4300901	Aratiba	RS	342.279
4314423	Picada Café	RS	84.28
4301008	Arroio do Meio	RS	157.088
4301057	Arroio do Sal	RS	119.16
4301073	Arroio do Padre	RS	124.693
4301636	Balneário Pinhal	RS	102.387
4301651	Barão	RS	124.757
4301701	Barão de Cotegipe	RS	260.505
4301750	Barão do Triunfo	RS	436.101
4301800	Barracão	RS	515.469
4314456	Pinhal	RS	68.222
4314464	Pinhal da Serra	RS	438.11
4314472	Pinhal Grande	RS	478.11
4314498	Pinheirinho do Vale	RS	105.385
4314506	Pinheiro Machado	RS	2249.176
4301859	Barra do Guarita	RS	62.801
4301875	Barra do Quaraí	RS	1055.937
4301909	Barra do Ribeiro	RS	729.316
4301925	Barra do Rio Azul	RS	146.995
4301958	Barra Funda	RS	60.437
4302006	Barros Cassal	RS	647.994
4302055	Benjamin Constant do Sul	RS	132.351
4302105	Bento Gonçalves	RS	272.287
4302154	Boa Vista das Missões	RS	196.064
4302204	Boa Vista do Buricá	RS	109.541
4302220	Boa Vista do Cadeado	RS	701.221
4302238	Boa Vista do Incra	RS	504.114
4302378	Bom Progresso	RS	89.206
4302659	Brochier	RS	105.353
4302709	Butiá	RS	752.187
4302808	Caçapava do Sul	RS	3048.147
4302907	Cacequi	RS	2373.507
4303004	Cachoeira do Sul	RS	3736.064
4303103	Cachoeirinha	RS	43.778
4303202	Cacique Doble	RS	204.055
4303301	Caibaté	RS	261.303
4303400	Caiçara	RS	189.16
4303509	Camaquã	RS	1680.168
4303806	Campinas do Sul	RS	276.162
4303905	Campo Bom	RS	60.579
4304630	Capão da Canoa	RS	98.383
4304655	Capão do Cipó	RS	1007.796
4304663	Capão do Leão	RS	783.196
4304002	Campo Novo	RS	220.719
4304101	Campos Borges	RS	226.202
4304606	Canoas	RS	130.789
4304614	Canudos do Vale	RS	82.908
4304622	Capão Bonito do Sul	RS	526.85
4305157	Cerro Grande	RS	73.438
4305173	Cerro Grande do Sul	RS	324.908
4304671	Capivari do Sul	RS	412.889
4304689	Capela de Santana	RS	182.756
4304697	Capitão	RS	73.967
4304705	Carazinho	RS	666.694
4305207	Cerro Largo	RS	176.643
4305306	Chapada	RS	684.247
4305355	Charqueadas	RS	217.362
4305371	Charrua	RS	198.748
4305405	Chiapetta	RS	397.179
4304713	Caraá	RS	294.606
4304804	Carlos Barbosa	RS	230.061
4304853	Carlos Gomes	RS	83.155
4304903	Casca	RS	272.041
4304952	Caseiros	RS	235.863
4305009	Catuípe	RS	583.184
4305108	Caxias do Sul	RS	1652.32
4305116	Centenário	RS	134.23
4305124	Cerrito	RS	451.699
4305132	Cerro Branco	RS	158.025
4306452	Dois Lajeados	RS	133.535
4306502	Dom Feliciano	RS	1355.195
4305439	Chuí	RS	202.387
4306551	Dom Pedro de Alcântara	RS	78.219
4306601	Dom Pedrito	RS	5194.051
4305447	Chuvisca	RS	220.471
4306700	Dona Francisca	RS	114.149
4306734	Doutor Maurício Cardoso	RS	255.731
4306759	Doutor Ricardo	RS	107.96
4306767	Eldorado do Sul	RS	509.614
4305454	Cidreira	RS	243.419
4306924	Engenho Velho	RS	71.191
4306932	Entre-Ijuís	RS	552.986
4306957	Entre Rios do Sul	RS	119.912
4306973	Erebango	RS	152.793
4307005	Erechim	RS	429.164
4305504	Ciríaco	RS	274.35
4307450	Esperança do Sul	RS	148.909
4307500	Espumoso	RS	783.642
4305587	Colinas	RS	60.732
4305603	Colorado	RS	286.295
4305702	Condor	RS	463.568
4314787	Ponte Preta	RS	99.504
4314803	Portão	RS	159.298
4314902	Porto Alegre	RS	495.39
4315008	Porto Lucena	RS	250.876
4315057	Porto Mauá	RS	105.811
4305801	Constantina	RS	203.614
4305835	Coqueiro Baixo	RS	112.638
4305850	Coqueiros do Sul	RS	277.147
4305871	Coronel Barros	RS	163.684
4305900	Coronel Bicaco	RS	492.303
4315073	Porto Vera Cruz	RS	114.284
4315107	Porto Xavier	RS	281.497
4315131	Pouso Novo	RS	105.338
4305934	Coronel Pilar	RS	105.668
4305959	Cotiporã	RS	173.207
4305975	Coxilha	RS	422.101
4306007	Crissiumal	RS	362.194
4315313	Quatro Irmãos	RS	268.971
4306056	Cristal	RS	682.138
4306072	Cristal do Sul	RS	97.077
4306106	Cruz Alta	RS	1360.548
4315552	Rio dos Índios	RS	235.854
4315602	Rio Grande	RS	2682.867
4315701	Rio Pardo	RS	2051.112
4315750	Riozinho	RS	239.09
4306130	Cruzaltense	RS	166.883
4306205	Cruzeiro do Sul	RS	155.058
4307708	Esteio	RS	27.676
4316709	Santa Bárbara do Sul	RS	975.799
4316733	Santa Cecília do Sul	RS	200.056
4306304	David Canabarro	RS	174.734
4306320	Derrubadas	RS	360.851
4306353	Dezesseis de Novembro	RS	217.363
4306379	Dilermando de Aguiar	RS	600.518
4306403	Dois Irmãos	RS	66.114
4306429	Dois Irmãos das Missões	RS	226.072
4316758	Santa Clara do Sul	RS	86.442
4316808	Santa Cruz do Sul	RS	733.898
4316907	Santa Maria	RS	1780.194
4316956	Santa Maria do Herval	RS	140.437
4316972	Santa Margarida do Sul	RS	955.299
4317004	Santana da Boa Vista	RS	1418.805
4317103	Sant'Ana do Livramento	RS	6946.407
4317202	Santa Rosa	RS	489.38
4306809	Encantado	RS	140.006
4306908	Encruzilhada do Sul	RS	3347.861
4317251	Santa Tereza	RS	73.669
4317301	Santa Vitória do Palmar	RS	5206.977
4317400	Santiago	RS	2414.195
4317509	Santo Ângelo	RS	679.34
4307054	Ernestina	RS	238.558
4307104	Herval	RS	1759.717
4307203	Erval Grande	RS	285.677
4307302	Erval Seco	RS	357.181
4307401	Esmeralda	RS	829.587
4307559	Estação	RS	99.757
4308003	Faxinal do Soturno	RS	169.514
4308052	Faxinalzinho	RS	143.321
4308078	Fazenda Vilanova	RS	84.794
4307609	Estância Velha	RS	51.779
4307807	Estrela	RS	185.026
4307815	Estrela Velha	RS	281.613
4307831	Eugênio de Castro	RS	418.069
4307864	Fagundes Varela	RS	134.295
4307906	Farroupilha	RS	361.341
4308102	Feliz	RS	94.832
4308201	Flores da Cunha	RS	276.241
4308250	Floriano Peixoto	RS	168.521
4308300	Fontoura Xavier	RS	583.239
4308409	Formigueiro	RS	578.875
4308433	Forquetinha	RS	93.275
4308458	Fortaleza dos Valos	RS	650.512
4308508	Frederico Westphalen	RS	265.181
4308607	Garibaldi	RS	168.492
4309126	Gramado dos Loureiros	RS	131.396
4309159	Gramado Xavier	RS	217.515
4309209	Gravataí	RS	468.288
4309258	Guabiju	RS	146.925
4309308	Guaíba	RS	376.166
4308656	Garruchos	RS	803.737
4308706	Gaurama	RS	204.428
4308805	General Câmara	RS	510.01
4309407	Guaporé	RS	297.545
4309506	Guarani das Missões	RS	290.7
4309555	Harmonia	RS	48.557
4308854	Gentil	RS	184.715
4308904	Getúlio Vargas	RS	287.466
4309001	Giruá	RS	857.059
4309050	Glorinha	RS	323.955
4309100	Gramado	RS	239.341
4309571	Herveiras	RS	118.261
4309605	Horizontina	RS	229.694
4309654	Hulha Negra	RS	822.608
4309704	Humaitá	RS	135.01
4309753	Ibarama	RS	195.426
4309803	Ibiaçá	RS	348.778
4309902	Ibiraiaras	RS	292.16
4309951	Ibirapuitã	RS	307.164
4310009	Ibirubá	RS	607.185
4310108	Igrejinha	RS	138.303
4310207	Ijuí	RS	688.982
4310306	Ilópolis	RS	123.602
4310330	Imbé	RS	39.766
4310538	Itaara	RS	172.801
4310553	Itacurubi	RS	1120.874
4312005	Mariano Moro	RS	98.727
4310579	Itapuca	RS	184.673
4310603	Itaqui	RS	3406.606
4310652	Itati	RS	205.06
4310702	Itatiba do Sul	RS	212.669
4310751	Ivorá	RS	122.93
4312054	Marques de Souza	RS	125.714
4312104	Mata	RS	316.121
4312138	Mato Castelhano	RS	238.268
4311130	Jari	RS	853.08
4311155	Jóia	RS	1238.918
4311205	Júlio de Castilhos	RS	1929.544
4311239	Lagoa Bonita do Sul	RS	109.758
4311254	Lagoão	RS	387.486
4311270	Lagoa dos Três Cantos	RS	138.602
4311304	Lagoa Vermelha	RS	1260.227
4311403	Lajeado	RS	91.231
4311429	Lajeado do Bugre	RS	67.947
4311502	Lavras do Sul	RS	2600.969
4311601	Liberato Salzano	RS	245.627
4311627	Lindolfo Collor	RS	33.351
4312385	Monte Belo do Sul	RS	69.726
4312401	Montenegro	RS	425.023
4311718	Maçambará	RS	1682.82
4311734	Mampituba	RS	156.653
4311908	Marcelino Ramos	RS	229.759
4311981	Mariana Pimentel	RS	338.45
4312153	Mato Leitão	RS	46.799
4312179	Mato Queimado	RS	114.653
4317558	Santo Antônio do Palma	RS	126.094
4317608	Santo Antônio da Patrulha	RS	1049.583
4317707	Santo Antônio das Missões	RS	1710.869
4312203	Maximiliano de Almeida	RS	208.439
4312252	Minas do Leão	RS	424.339
4312302	Miraguaí	RS	131.236
4312351	Montauri	RS	82.23
4312377	Monte Alegre dos Campos	RS	549.455
4312427	Mormaço	RS	146.191
4312443	Morrinhos do Sul	RS	166.224
4312500	Mostardas	RS	1977.442
4312658	Não-Me-Toque	RS	361.689
4312674	Nicolau Vergueiro	RS	154.995
4312708	Nonoai	RS	468.962
4312757	Nova Alvorada	RS	148.861
4312807	Nova Araçá	RS	75.514
4312906	Nova Bassano	RS	211.611
4312955	Nova Boa Vista	RS	93.733
4313003	Nova Bréscia	RS	102.994
4313011	Nova Candelária	RS	97.579
4313037	Nova Esperança do Sul	RS	191
4313060	Nova Hartz	RS	62.319
4313086	Nova Pádua	RS	102.643
4313102	Nova Palma	RS	314.613
4313201	Nova Petrópolis	RS	290.164
4313300	Nova Prata	RS	259.941
4313375	Nova Santa Rita	RS	218.153
4313391	Novo Cabrais	RS	192.998
4313409	Novo Hamburgo	RS	222.536
4313425	Novo Machado	RS	218.836
4313953	Pantano Grande	RS	841.225
4314001	Paraí	RS	121.745
4314027	Paraíso do Sul	RS	337.534
4314035	Pareci Novo	RS	57.485
4314050	Parobé	RS	108.707
4314068	Passa Sete	RS	304.266
4314548	Pinto Bandeira	RS	104.801
4314555	Pirapó	RS	293.723
4314605	Piratini	RS	3538.3
4314704	Planalto	RS	228.552
4314753	Poço das Antas	RS	67.618
4314779	Pontão	RS	502.709
4315149	Presidente Lucena	RS	49.628
4315156	Progresso	RS	256.039
4315172	Protásio Alves	RS	171.994
4315206	Putinga	RS	216.159
4315305	Quaraí	RS	3139.995
4315321	Quevedos	RS	543.359
4315354	Quinze de Novembro	RS	223.072
4315404	Redentora	RS	303.705
4315453	Relvado	RS	108.188
4315503	Restinga Sêca	RS	968.62
4315800	Roca Sales	RS	208.108
4315909	Rodeio Bonito	RS	83.278
4315958	Rolador	RS	295.326
4316006	Rolante	RS	296.09
4316105	Ronda Alta	RS	418.675
4317954	Santo Expedito do Sul	RS	125.595
4318002	São Borja	RS	3616.69
4316204	Rondinha	RS	252.454
4316303	Roque Gonzales	RS	349.074
4316402	Rosário do Sul	RS	4343.656
4316428	Sagrada Família	RS	77.889
4316436	Saldanha Marinho	RS	221.554
4316451	Salto do Jacuí	RS	507.698
4320651	Silveira Martins	RS	119.285
4320677	Sinimbu	RS	510.213
4320701	Sobradinho	RS	128.823
4320800	Soledade	RS	1215.056
4316477	Salvador das Missões	RS	94.312
4316501	Salvador do Sul	RS	99.156
4316600	Sananduva	RS	504.438
4317756	Santo Antônio do Planalto	RS	203.44
4317806	Santo Augusto	RS	467.775
4317905	Santo Cristo	RS	367.202
4320859	Tabaí	RS	94.754
4320909	Tapejara	RS	238.082
4321006	Tapera	RS	179.935
4318051	São Domingos do Sul	RS	78.67
4318101	São Francisco de Assis	RS	2506.975
4318200	São Francisco de Paula	RS	3317.794
4318309	São Gabriel	RS	5053.46
4318408	São Jerônimo	RS	935.596
4318424	São João da Urtiga	RS	171.029
4318432	São João do Polêsine	RS	78.32
4318440	São Jorge	RS	125.62
4318457	São José das Missões	RS	98.125
4318465	São José do Herval	RS	102.912
4318481	São José do Hortêncio	RS	63.709
4318499	São José do Inhacorá	RS	77.732
4318507	São José do Norte	RS	1071.824
4318606	São José do Ouro	RS	335.287
4318614	São José do Sul	RS	54.764
4318622	São José dos Ausentes	RS	1173.907
4318705	São Leopoldo	RS	103.009
4318804	São Lourenço do Sul	RS	2036.125
4318903	São Luiz Gonzaga	RS	1295.522
4319000	São Marcos	RS	256.159
4319109	São Martinho	RS	171.245
4319125	São Martinho da Serra	RS	669.547
4319158	São Miguel das Missões	RS	1228.447
4319208	São Nicolau	RS	485.588
4319307	São Paulo das Missões	RS	223.942
4319356	São Pedro da Serra	RS	35.207
4319364	São Pedro das Missões	RS	79.894
4319372	São Pedro do Butiá	RS	107.559
4319406	São Pedro do Sul	RS	873.394
4319505	São Sebastião do Caí	RS	114.293
4319604	São Sepé	RS	2204.779
4319703	São Valentim	RS	154.45
4319711	São Valentim do Sul	RS	91.898
4319737	São Valério do Sul	RS	107.402
4319752	São Vendelino	RS	31.935
4319802	São Vicente do Sul	RS	1174.822
4319901	Sapiranga	RS	136.473
4321451	Teutônia	RS	177.795
4321469	Tio Hugo	RS	113.944
4321477	Tiradentes do Sul	RS	236.653
4321493	Toropi	RS	198.316
4320008	Sapucaia do Sul	RS	58.247
4320107	Sarandi	RS	351.717
4320206	Seberi	RS	300.827
4321501	Torres	RS	161.627
4320230	Sede Nova	RS	119.312
4320263	Segredo	RS	245.17
4320305	Selbach	RS	176.471
4320321	Senador Salgado Filho	RS	147.068
4320354	Sentinela do Sul	RS	282.13
4320404	Serafina Corrêa	RS	163.31
4320453	Sério	RS	98.131
4320503	Sertão	RS	440.631
4320552	Sertão Santana	RS	252.013
4320578	Sete de Setembro	RS	129.238
4320602	Severiano de Almeida	RS	167.598
4321105	Tapes	RS	805.452
4321204	Taquara	RS	452.572
4321303	Taquari	RS	349.967
4321600	Tramandaí	RS	142.878
4321329	Taquaruçu do Sul	RS	76.917
4321352	Tavares	RS	610.106
4321402	Tenente Portela	RS	337.495
4322186	Tupanci do Sul	RS	135.243
4322202	Tupanciretã	RS	2253.234
4321436	Terra de Areia	RS	142.304
4321626	Travesseiro	RS	80.681
4321634	Três Arroios	RS	148.601
4321667	Três Cachoeiras	RS	251.483
4321709	Três Coroas	RS	165.285
4321808	Três de Maio	RS	421.461
4321832	Três Forquilhas	RS	217.386
4321857	Três Palmeiras	RS	180.599
4321907	Três Passos	RS	268.902
4322525	Vale Verde	RS	329.727
4321956	Trindade do Sul	RS	268.417
4322541	Vale Real	RS	45.085
4322004	Triunfo	RS	817.625
4322103	Tucunduva	RS	181.198
4322152	Tunas	RS	217.302
4322251	Tupandi	RS	59.447
4322301	Tuparendi	RS	307.71
4322327	Turuçu	RS	253.635
4322343	Ubiretama	RS	125.876
4322350	União da Serra	RS	131.154
4322376	Unistalda	RS	602.387
4322400	Uruguaiana	RS	5702.098
4322509	Vacaria	RS	2124.492
4322855	Vespasiano Corrêa	RS	113.622
4322905	Viadutos	RS	268.072
4323002	Viamão	RS	1496.506
4322533	Vale do Sol	RS	328.275
4323754	Vitória das Missões	RS	258.312
4323770	Westfália	RS	63.665
4322558	Vanini	RS	64.905
4322608	Venâncio Aires	RS	772.588
4322707	Vera Cruz	RS	309.621
5003256	Costa Rica	MS	4159.384
5003306	Coxim	MS	6391.486
5003454	Deodápolis	MS	828.533
5003488	Dois Irmãos do Buriti	MS	2431.609
4322806	Veranópolis	RS	289.397
4323101	Vicente Dutra	RS	193.025
4323200	Victor Graeff	RS	238.133
5003702	Dourados	MS	4062.236
5003751	Eldorado	MS	1012.796
5003801	Fátima do Sul	MS	315.333
5003900	Figueirão	MS	4879.932
5004007	Glória de Dourados	MS	493.434
5004106	Guia Lopes da Laguna	MS	1225.426
5004304	Iguatemi	MS	2957.41
5004403	Inocência	MS	5761.19
5004502	Itaporã	MS	1342.764
5004601	Itaquiraí	MS	2063.717
5004700	Ivinhema	MS	2003.43
5004809	Japorã	MS	416.605
5004908	Jaraguari	MS	2912.836
5005004	Jardim	MS	2126.133
5005103	Jateí	MS	1933.316
5005152	Juti	MS	1569.176
4323309	Vila Flores	RS	107.703
4323358	Vila Lângaro	RS	151.695
5005202	Ladário	MS	354.255
5005251	Laguna Carapã	MS	1725.78
5005400	Maracaju	MS	5396.905
5005608	Miranda	MS	5471.436
5005681	Mundo Novo	MS	478.38
5005707	Naviraí	MS	3189.667
5005806	Nioaque	MS	3909.44
5006002	Nova Alvorada do Sul	MS	4025.012
5006200	Nova Andradina	MS	4770.685
5006259	Novo Horizonte do Sul	MS	849.19
5006275	Paraíso das Águas	MS	5061.433
5006309	Paranaíba	MS	5405.48
5006358	Paranhos	MS	1307.092
5006408	Pedro Gomes	MS	3553.782
5006606	Ponta Porã	MS	5359.354
5006903	Porto Murtinho	MS	17505.2
5007109	Ribas do Rio Pardo	MS	17315.283
5007208	Rio Brilhante	MS	3983.562
5007307	Rio Negro	MS	1828.8
5007406	Rio Verde de Mato Grosso	MS	8173.868
4323408	Vila Maria	RS	181.061
4323457	Vila Nova do Sul	RS	508.278
4323507	Vista Alegre	RS	77.63
4323606	Vista Alegre do Prata	RS	119.327
5007505	Rochedo	MS	1309.574
5007554	Santa Rita do Pardo	MS	6142.001
5007695	São Gabriel do Oeste	MS	3849.875
5007703	Sete Quedas	MS	839.117
5007802	Selvíria	MS	3254.917
5007901	Sidrolândia	MS	5265.695
4323705	Vista Gaúcha	RS	90.022
4323804	Xangri-lá	RS	60.756
5000203	Água Clara	MS	7781.558
5000252	Alcinópolis	MS	4397.518
5000609	Amambai	MS	4193.742
5000708	Anastácio	MS	2913.177
5000807	Anaurilândia	MS	3415.657
5000856	Angélica	MS	1283.627
5000906	Antônio João	MS	1142.895
5001003	Aparecida do Taboado	MS	2751.485
5001102	Aquidauana	MS	17087.021
5001243	Aral Moreira	MS	1653.86
5001508	Bandeirantes	MS	3357.926
5001904	Bataguassu	MS	2392.476
5002001	Batayporã	MS	1826.578
5002100	Bela Vista	MS	4899.44
5002159	Bodoquena	MS	2591.933
5002209	Bonito	MS	5373.016
5002308	Brasilândia	MS	5803.542
5002407	Caarapó	MS	2115.73
5002605	Camapuã	MS	6238.127
5002704	Campo Grande	MS	8082.978
5002803	Caracol	MS	2943.206
5002902	Cassilândia	MS	3658.252
5002951	Chapadão do Sul	MS	3252.327
5003108	Corguinho	MS	2639.657
5003157	Coronel Sapucaia	MS	1023.727
5003207	Corumbá	MS	64432.45
5003504	Douradina	MS	280.457
5008404	Vicentina	MS	312.429
5100102	Acorizal	MT	850.763
5100201	Água Boa	MT	7549.308
5100250	Alta Floresta	MT	8955.41
5100300	Alto Araguaia	MT	5402.308
5100359	Alto Boa Vista	MT	2248.414
5100409	Alto Garças	MT	3858.153
5100508	Alto Paraguai	MT	1847.354
5100607	Alto Taquari	MT	1436.582
5100805	Apiacás	MT	20489.024
5101001	Araguaiana	MT	6380.7
5101209	Araguainha	MT	675.231
5101258	Araputanga	MT	1639.733
5101308	Arenápolis	MT	417.337
5101407	Aripuanã	MT	24678.135
5101605	Barão de Melgaço	MT	11374.872
5101704	Barra do Bugres	MT	5976.864
5101803	Barra do Garças	MT	8363.149
5101852	Bom Jesus do Araguaia	MT	4266.636
5101902	Brasnorte	MT	15968.355
5102504	Cáceres	MT	24495.51
5102603	Campinápolis	MT	5978.985
5102637	Campo Novo do Parecis	MT	9428.586
5102678	Campo Verde	MT	4770.631
5102686	Campos de Júlio	MT	6792.808
5102694	Canabrava do Norte	MT	3449.037
5102702	Canarana	MT	10855.181
5102793	Carlinda	MT	2421.788
5102850	Castanheira	MT	3713.466
5103007	Chapada dos Guimarães	MT	6603.252
5103056	Cláudia	MT	3843.561
5103106	Cocalinho	MT	16563.136
5103205	Colíder	MT	3112.091
5103254	Colniza	MT	27960.237
5103304	Comodoro	MT	21485.018
5103353	Confresa	MT	5802.314
5103361	Conquista D'Oeste	MT	2684.676
5103379	Cotriguaçu	MT	9469.957
5103403	Cuiabá	MT	4327.448
5103437	Curvelândia	MT	357.128
5103452	Denise	MT	1273.178
5103502	Diamantino	MT	8263.397
5103601	Dom Aquino	MT	2183.603
5103700	Feliz Natal	MT	11661.514
5103809	Figueirópolis D'Oeste	MT	891.448
5103858	Gaúcha do Norte	MT	16908.375
5103908	General Carneiro	MT	4514.917
5103957	Glória D'Oeste	MT	833.13
5104104	Guarantã do Norte	MT	4725.281
5104203	Guiratinga	MT	5043.899
5104500	Indiavaí	MT	592.495
\.


--
-- Data for Name: percepcao_seca; Type: TABLE DATA; Schema: monitor; Owner: postgres
--

COPY monitor.percepcao_seca (id_percepcao_seca, percepcao_seca) FROM stdin;
1	Houve melhora
2	Houve piora
3	Não houve alteração
4	Não há seca
99	Não sei opinar
\.


--
-- Data for Name: problema_restricao; Type: TABLE DATA; Schema: monitor; Owner: postgres
--

COPY monitor.problema_restricao (id_problema_restricao, problema_restricao) FROM stdin;
1	Sem problemas
2	Navegabilidade comprometida
3	Racionamento ou rodízio no abastecimento
4	Restrições ou suspensão de outorgas
5	Desabastecimento público
6	Potabilidade da Água
7	Mortandade de peixes
99	Não informado
8	Dessedentação Animal (morte de gado)
\.


--
-- Data for Name: qnt_chuva; Type: TABLE DATA; Schema: monitor; Owner: postgres
--

COPY monitor.qnt_chuva (id_qnt_chuva, qnt_chuva) FROM stdin;
1	Não choveu
2	Pouca chuva
3	Razoável
4	Muita Chuva
99	Não sei avaliar
\.


--
-- Data for Name: sit_cultura; Type: TABLE DATA; Schema: monitor; Owner: postgres
--

COPY monitor.sit_cultura (id_sit_cultura, sit_cultura) FROM stdin;
1	Não é época de plantio
2	Plantio atrasado
3	Nenhuma perda
4	Alguma perda
5	Grandes perdas
6	Perdas prováveis
99	Não sei informar
\.


--
-- Data for Name: tipo_cultura; Type: TABLE DATA; Schema: monitor; Owner: postgres
--

COPY monitor.tipo_cultura (id_tipo_cultura, tipo_cultura) FROM stdin;
1	Arroz
2	Cana-de-açúcar
3	Cevada
4	Feijão
5	Milho
6	Soja
7	Trigo
98	Outra
99	Não informado
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: impactos_seca_id_seq; Type: SEQUENCE SET; Schema: monitor; Owner: postgres
--

SELECT pg_catalog.setval('monitor.impactos_seca_id_seq', 103, true);


--
-- Name: topology_id_seq; Type: SEQUENCE SET; Schema: topology; Owner: postgres
--

SELECT pg_catalog.setval('topology.topology_id_seq', 1, false);


--
-- Name: acesso_agua acesso_agua_pkey; Type: CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.acesso_agua
    ADD CONSTRAINT acesso_agua_pkey PRIMARY KEY (id_acesso_agua);


--
-- Name: de_chuva de_chuva_pkey; Type: CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.de_chuva
    ADD CONSTRAINT de_chuva_pkey PRIMARY KEY (id_de_chuva);


--
-- Name: dt_chuva dt_chuva_pkey; Type: CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.dt_chuva
    ADD CONSTRAINT dt_chuva_pkey PRIMARY KEY (id_dt_chuva);


--
-- Name: qnt_chuva id_qnt_chuva_pk; Type: CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.qnt_chuva
    ADD CONSTRAINT id_qnt_chuva_pk PRIMARY KEY (id_qnt_chuva);


--
-- Name: impactos_seca impactos_seca_pk; Type: CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.impactos_seca
    ADD CONSTRAINT impactos_seca_pk PRIMARY KEY (id, cod_mun, ano_mes);


--
-- Name: limites_estaduais_ibge_2022 limites_estaduais_ibge_2022_pkey; Type: CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.limites_estaduais_ibge_2022
    ADD CONSTRAINT limites_estaduais_ibge_2022_pkey PRIMARY KEY (cod_uf);


--
-- Name: limites_municipais_ibge_2022 limites_municipais_ibge_2022_pkey; Type: CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.limites_municipais_ibge_2022
    ADD CONSTRAINT limites_municipais_ibge_2022_pkey PRIMARY KEY (cod_mun);


--
-- Name: percepcao_seca percepcao_subj_pkey; Type: CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.percepcao_seca
    ADD CONSTRAINT percepcao_subj_pkey PRIMARY KEY (id_percepcao_seca);


--
-- Name: problema_restricao problema_restricao_pkey; Type: CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.problema_restricao
    ADD CONSTRAINT problema_restricao_pkey PRIMARY KEY (id_problema_restricao);


--
-- Name: sit_cultura sit_cultura_pkey; Type: CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.sit_cultura
    ADD CONSTRAINT sit_cultura_pkey PRIMARY KEY (id_sit_cultura);


--
-- Name: tipo_cultura tipo_cultura_pkey; Type: CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.tipo_cultura
    ADD CONSTRAINT tipo_cultura_pkey PRIMARY KEY (id_tipo_cultura);


--
-- Name: view_impactos_seca _RETURN; Type: RULE; Schema: monitor; Owner: postgres
--

CREATE OR REPLACE VIEW monitor.view_impactos_seca AS
 SELECT impactos.id,
    impactos.cod_mun,
    t8.nome_mun,
    t8.sigla_uf AS uf,
    impactos.ano_mes,
    t0.dt_chuva AS distr_temp_chuva,
    t2.de_chuva AS distr_espac_chuva,
    t3.percepcao_seca,
    t5.qnt_chuva,
    t6.sit_cultura,
    ( SELECT array_agg(t7.tipo_cultura) AS array_agg
           FROM monitor.tipo_cultura t7
          WHERE (t7.id_tipo_cultura = ANY (impactos.tipo_cultura))) AS tipo_cultura,
    ( SELECT array_agg(t4.problema_restricao) AS array_agg
           FROM monitor.problema_restricao t4
          WHERE (t4.id_problema_restricao = ANY (impactos.problema_restricao))) AS problema_restricao,
    impactos.dt_inclusao
   FROM (((((((monitor.impactos_seca impactos
     JOIN monitor.acesso_agua t1 ON ((impactos.acesso_agua = t1.id_acesso_agua)))
     JOIN monitor.dt_chuva t0 ON ((impactos.dt_chuva = t0.id_dt_chuva)))
     JOIN monitor.de_chuva t2 ON ((impactos.de_chuva = t2.id_de_chuva)))
     JOIN monitor.percepcao_seca t3 ON ((impactos.percepcao_seca = t3.id_percepcao_seca)))
     JOIN monitor.qnt_chuva t5 ON ((impactos.qnt_chuva = t5.id_qnt_chuva)))
     JOIN monitor.sit_cultura t6 ON ((impactos.sit_cultura = t6.id_sit_cultura)))
     JOIN monitor.limites_municipais_ibge_2022 t8 ON ((impactos.cod_mun = t8.cod_mun)))
  GROUP BY impactos.id, impactos.cod_mun, t8.nome_mun, t8.sigla_uf, impactos.ano_mes, t0.dt_chuva, t2.de_chuva, t3.percepcao_seca, t5.qnt_chuva, t6.sit_cultura;


--
-- Name: view_impactos_seca_with_values _RETURN; Type: RULE; Schema: monitor; Owner: postgres
--

CREATE OR REPLACE VIEW monitor.view_impactos_seca_with_values AS
 SELECT impactos.id,
    impactos.cod_mun,
    t8.nome_mun,
    t8.sigla_uf AS uf,
    impactos.ano_mes,
    impactos.dt_chuva AS id_dt_chuva,
    t0.dt_chuva AS distr_temp_chuva,
    impactos.de_chuva AS id_de_chuva,
    t2.de_chuva AS distr_espac_chuva,
    impactos.percepcao_seca AS id_percepcao_seca,
    t3.percepcao_seca,
    impactos.qnt_chuva AS id_qnt_chuva,
    t5.qnt_chuva,
    t6.sit_cultura,
    impactos.tipo_cultura AS id_tipo_cultura,
    ( SELECT array_agg(t7.tipo_cultura) AS array_agg
           FROM monitor.tipo_cultura t7
          WHERE (t7.id_tipo_cultura = ANY (impactos.tipo_cultura))) AS tipo_cultura,
    impactos.problema_restricao AS id_problema_restricao,
    ( SELECT array_agg(t4.problema_restricao) AS array_agg
           FROM monitor.problema_restricao t4
          WHERE (t4.id_problema_restricao = ANY (impactos.problema_restricao))) AS problema_restricao,
    impactos.dt_inclusao
   FROM (((((((monitor.impactos_seca impactos
     JOIN monitor.acesso_agua t1 ON ((impactos.acesso_agua = t1.id_acesso_agua)))
     JOIN monitor.dt_chuva t0 ON ((impactos.dt_chuva = t0.id_dt_chuva)))
     JOIN monitor.de_chuva t2 ON ((impactos.de_chuva = t2.id_de_chuva)))
     JOIN monitor.percepcao_seca t3 ON ((impactos.percepcao_seca = t3.id_percepcao_seca)))
     JOIN monitor.qnt_chuva t5 ON ((impactos.qnt_chuva = t5.id_qnt_chuva)))
     JOIN monitor.sit_cultura t6 ON ((impactos.sit_cultura = t6.id_sit_cultura)))
     JOIN monitor.limites_municipais_ibge_2022 t8 ON ((impactos.cod_mun = t8.cod_mun)))
  GROUP BY impactos.id, impactos.cod_mun, t8.nome_mun, t8.sigla_uf, impactos.ano_mes, t0.dt_chuva, t2.de_chuva, t3.percepcao_seca, t5.qnt_chuva, t6.sit_cultura;


--
-- Name: impactos_seca reset_sequence_trigger; Type: TRIGGER; Schema: monitor; Owner: postgres
--

CREATE TRIGGER reset_sequence_trigger BEFORE INSERT ON monitor.impactos_seca FOR EACH ROW EXECUTE FUNCTION public.reset_sequence_trigger();


--
-- Name: impactos_seca acesso_agua_fkey; Type: FK CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.impactos_seca
    ADD CONSTRAINT acesso_agua_fkey FOREIGN KEY (acesso_agua) REFERENCES monitor.acesso_agua(id_acesso_agua) NOT VALID;


--
-- Name: impactos_seca cod_mun_fkey; Type: FK CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.impactos_seca
    ADD CONSTRAINT cod_mun_fkey FOREIGN KEY (cod_mun) REFERENCES monitor.limites_municipais_ibge_2022(cod_mun) NOT VALID;


--
-- Name: impactos_seca de_chuva_fkey; Type: FK CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.impactos_seca
    ADD CONSTRAINT de_chuva_fkey FOREIGN KEY (de_chuva) REFERENCES monitor.de_chuva(id_de_chuva) NOT VALID;


--
-- Name: impactos_seca dt_chuva_pkey; Type: FK CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.impactos_seca
    ADD CONSTRAINT dt_chuva_pkey FOREIGN KEY (dt_chuva) REFERENCES monitor.dt_chuva(id_dt_chuva) NOT VALID;


--
-- Name: impactos_seca percepcao_seca_fkey; Type: FK CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.impactos_seca
    ADD CONSTRAINT percepcao_seca_fkey FOREIGN KEY (percepcao_seca) REFERENCES monitor.percepcao_seca(id_percepcao_seca) NOT VALID;


--
-- Name: impactos_seca qnt_chuva_fkey; Type: FK CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.impactos_seca
    ADD CONSTRAINT qnt_chuva_fkey FOREIGN KEY (qnt_chuva) REFERENCES monitor.qnt_chuva(id_qnt_chuva) NOT VALID;


--
-- Name: impactos_seca sit_cultura_fkey; Type: FK CONSTRAINT; Schema: monitor; Owner: postgres
--

ALTER TABLE ONLY monitor.impactos_seca
    ADD CONSTRAINT sit_cultura_fkey FOREIGN KEY (sit_cultura) REFERENCES monitor.sit_cultura(id_sit_cultura) NOT VALID;


--
-- PostgreSQL database dump complete
--

