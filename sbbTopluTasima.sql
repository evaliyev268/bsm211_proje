--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

-- Started on 2024-12-23 01:08:05

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

--
-- TOC entry 253 (class 1255 OID 33573)
-- Name: bakimDurumuGuncelle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."bakimDurumuGuncelle"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "Araclar"
SET "bakimDurumu"=TRUE
WHERE "aracID"=NEW."aracID";
RETURN NEW;
END;
$$;


ALTER FUNCTION public."bakimDurumuGuncelle"() OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 33571)
-- Name: bakimYap(integer, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."bakimYap"(IN arac_id integer, IN detaylar text)
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO "AracBakim"("aracID","bakimTarihi","detaylar")
VALUES("arac_id",CURRENT_DATE,"detaylar");
END;
$$;


ALTER PROCEDURE public."bakimYap"(IN arac_id integer, IN detaylar text) OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 33575)
-- Name: kapasiteAzalt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."kapasiteAzalt"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "Araclar"
SET "kapasite"="kapasite"-1
WHERE "aracID"=NEW."aracID";
IF (SELECT "kapasite" FROM "Araclar" WHERE "aracID"=NEW."aracID")<0 THEN
RAISE EXCEPTION 'Aracta yer kalmadi!';
END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION public."kapasiteAzalt"() OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 33570)
-- Name: puanVer(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."puanVer"(IN surucu_id integer, IN puan integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO "SurucuPuani"("surucuID","puan","tarih")
VALUES ("surucu_id","puan",CURRENT_DATE);
END;
$$;


ALTER PROCEDURE public."puanVer"(IN surucu_id integer, IN puan integer) OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 33579)
-- Name: sikayetTarihiGuncelle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."sikayetTarihiGuncelle"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "Sikayetler"
SET "tarih"=CURRENT_DATE
WHERE "sikayetID"=NEW."sikayetID";
RETURN NEW;
END;
$$;


ALTER FUNCTION public."sikayetTarihiGuncelle"() OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 33568)
-- Name: surucuPuanOrtalamasiHesapla(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."surucuPuanOrtalamasiHesapla"("surucuId" integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE 
"ortalama" DECIMAL;
BEGIN
SELECT AVG("puan") INTO "ortalama"
FROM "SurucuPuani"
WHERE "surucuID"="surucuId";
RETURN "ortalama";
END;
$$;


ALTER FUNCTION public."surucuPuanOrtalamasiHesapla"("surucuId" integer) OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 33569)
-- Name: yeniSeferEkle(integer, integer, character varying, date, time without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."yeniSeferEkle"(arac_id integer, surucu_id integer, guzergah character varying, tarih date, saat time without time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
"yeniSeferID" INTEGER;
BEGIN
INSERT INTO "Seferler"("aracID","surucuID","guzergah","tarih","saat" )
VALUES("arac_id","surucu_id","guzergah","tarih","saat")
RETURNING "seferID" INTO "yeniSeferID";
RETURN "yeniSeferID";
END;
$$;


ALTER FUNCTION public."yeniSeferEkle"(arac_id integer, surucu_id integer, guzergah character varying, tarih date, saat time without time zone) OWNER TO postgres;

--
-- TOC entry 255 (class 1255 OID 33577)
-- Name: yorumTarihiGuncelle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."yorumTarihiGuncelle"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "DurakYorumlari"
SET "tarih"=CURRENT_DATE
WHERE "yorumID"=NEW."yorumID";
RETURN NEW;
END;
$$;


ALTER FUNCTION public."yorumTarihiGuncelle"() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 234 (class 1259 OID 33455)
-- Name: AracBakim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."AracBakim" (
    "bakimID" integer NOT NULL,
    "aracID" integer,
    "bakimTarihi" date,
    detaylar text
);


ALTER TABLE public."AracBakim" OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 33454)
-- Name: AracBakim_bakimID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."AracBakim_bakimID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."AracBakim_bakimID_seq" OWNER TO postgres;

--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 233
-- Name: AracBakim_bakimID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."AracBakim_bakimID_seq" OWNED BY public."AracBakim"."bakimID";


--
-- TOC entry 232 (class 1259 OID 33446)
-- Name: AracModelleri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."AracModelleri" (
    "aracModelID" integer NOT NULL,
    isim character varying,
    ozellikler text
);


ALTER TABLE public."AracModelleri" OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 33445)
-- Name: AracModelleri_aracModelID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."AracModelleri_aracModelID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."AracModelleri_aracModelID_seq" OWNER TO postgres;

--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 231
-- Name: AracModelleri_aracModelID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."AracModelleri_aracModelID_seq" OWNED BY public."AracModelleri"."aracModelID";


--
-- TOC entry 218 (class 1259 OID 33349)
-- Name: Araclar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Araclar" (
    "aracID" integer NOT NULL,
    "plakaNO" character varying(10),
    kapasite integer,
    "bakimDurumu" boolean,
    "aracKategorisi" character varying
);


ALTER TABLE public."Araclar" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 33348)
-- Name: Araclar_aracID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Araclar_aracID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Araclar_aracID_seq" OWNER TO postgres;

--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 217
-- Name: Araclar_aracID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Araclar_aracID_seq" OWNED BY public."Araclar"."aracID";


--
-- TOC entry 244 (class 1259 OID 33523)
-- Name: Biletler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Biletler" (
    "biletID" integer NOT NULL,
    "seferID" integer,
    "yolcuID" integer,
    "biletTutari" numeric,
    "satildigiTarih" date
);


ALTER TABLE public."Biletler" OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 33522)
-- Name: Biletler_biletID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Biletler_biletID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Biletler_biletID_seq" OWNER TO postgres;

--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 243
-- Name: Biletler_biletID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Biletler_biletID_seq" OWNED BY public."Biletler"."biletID";


--
-- TOC entry 240 (class 1259 OID 33490)
-- Name: DurakYorumlari; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."DurakYorumlari" (
    "yorumID" integer NOT NULL,
    "durakID" integer,
    "yolcuID" integer,
    yorum text,
    tarih date
);


ALTER TABLE public."DurakYorumlari" OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 33489)
-- Name: DurakYorumlari_yorumID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."DurakYorumlari_yorumID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."DurakYorumlari_yorumID_seq" OWNER TO postgres;

--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 239
-- Name: DurakYorumlari_yorumID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."DurakYorumlari_yorumID_seq" OWNED BY public."DurakYorumlari"."yorumID";


--
-- TOC entry 238 (class 1259 OID 33481)
-- Name: Duraklar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Duraklar" (
    "durakID" integer NOT NULL,
    isim character varying,
    konum character varying
);


ALTER TABLE public."Duraklar" OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 33480)
-- Name: Duraklar_durakID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Duraklar_durakID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Duraklar_durakID_seq" OWNER TO postgres;

--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 237
-- Name: Duraklar_durakID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Duraklar_durakID_seq" OWNED BY public."Duraklar"."durakID";


--
-- TOC entry 222 (class 1259 OID 33365)
-- Name: Guzergahlar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Guzergahlar" (
    "guzergahID" integer NOT NULL,
    isim character varying,
    baslangic character varying,
    bitis character varying
);


ALTER TABLE public."Guzergahlar" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 33364)
-- Name: Guzergahlar_guzergahID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Guzergahlar_guzergahID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Guzergahlar_guzergahID_seq" OWNER TO postgres;

--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 221
-- Name: Guzergahlar_guzergahID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Guzergahlar_guzergahID_seq" OWNED BY public."Guzergahlar"."guzergahID";


--
-- TOC entry 228 (class 1259 OID 33416)
-- Name: MinibusSurucusu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."MinibusSurucusu" (
    "surucuID" integer NOT NULL,
    "minibusTecrubesi" integer
);


ALTER TABLE public."MinibusSurucusu" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 33394)
-- Name: Minibusler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Minibusler" (
    "aracID" integer NOT NULL,
    "minibusTuru" character varying
);


ALTER TABLE public."Minibusler" OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 33551)
-- Name: Odemeler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Odemeler" (
    "odemeID" integer NOT NULL,
    "biletID" integer,
    "odemeTarihi" date,
    tutar numeric
);


ALTER TABLE public."Odemeler" OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 33550)
-- Name: Odemeler_odemeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Odemeler_odemeID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Odemeler_odemeID_seq" OWNER TO postgres;

--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 247
-- Name: Odemeler_odemeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Odemeler_odemeID_seq" OWNED BY public."Odemeler"."odemeID";


--
-- TOC entry 227 (class 1259 OID 33406)
-- Name: OtobusSurucusu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."OtobusSurucusu" (
    "surucuID" integer NOT NULL,
    "otobusTecrubesi" integer
);


ALTER TABLE public."OtobusSurucusu" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 33382)
-- Name: Otobusler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Otobusler" (
    "aracID" integer NOT NULL,
    "otobusTuru" character varying
);


ALTER TABLE public."Otobusler" OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 33542)
-- Name: Promosyonlar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Promosyonlar" (
    "promosyonID" integer NOT NULL,
    isim character varying,
    "indirimOrani" numeric,
    "gecerlilikTarihi" date
);


ALTER TABLE public."Promosyonlar" OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 33541)
-- Name: Promosyonlar_promosyonID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Promosyonlar_promosyonID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Promosyonlar_promosyonID_seq" OWNER TO postgres;

--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 245
-- Name: Promosyonlar_promosyonID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Promosyonlar_promosyonID_seq" OWNED BY public."Promosyonlar"."promosyonID";


--
-- TOC entry 230 (class 1259 OID 33427)
-- Name: Seferler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Seferler" (
    "seferID" integer NOT NULL,
    "aracID" integer,
    "surucuID" integer,
    guzergah character varying,
    tarih date,
    saat time without time zone
);


ALTER TABLE public."Seferler" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 33426)
-- Name: Seferler_seferID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Seferler_seferID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Seferler_seferID_seq" OWNER TO postgres;

--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 229
-- Name: Seferler_seferID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Seferler_seferID_seq" OWNED BY public."Seferler"."seferID";


--
-- TOC entry 242 (class 1259 OID 33509)
-- Name: Sikayetler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Sikayetler" (
    "sikayetID" integer NOT NULL,
    "yolcuID" integer,
    konu character varying,
    detay text,
    tarih date
);


ALTER TABLE public."Sikayetler" OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 33508)
-- Name: Sikayetler_sikayetID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Sikayetler_sikayetID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Sikayetler_sikayetID_seq" OWNER TO postgres;

--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 241
-- Name: Sikayetler_sikayetID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Sikayetler_sikayetID_seq" OWNED BY public."Sikayetler"."sikayetID";


--
-- TOC entry 236 (class 1259 OID 33469)
-- Name: SurucuPuani; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SurucuPuani" (
    "puanID" integer NOT NULL,
    "surucuID" integer,
    puan integer,
    tarih date
);


ALTER TABLE public."SurucuPuani" OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 33468)
-- Name: SurucuPuani_puanID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."SurucuPuani_puanID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."SurucuPuani_puanID_seq" OWNER TO postgres;

--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 235
-- Name: SurucuPuani_puanID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."SurucuPuani_puanID_seq" OWNED BY public."SurucuPuani"."puanID";


--
-- TOC entry 220 (class 1259 OID 33356)
-- Name: Suruculer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Suruculer" (
    "surucuID" integer NOT NULL,
    ad character varying,
    soyad character varying,
    "ehliyetTipi" character varying,
    "surucuKategorisi" character varying
);


ALTER TABLE public."Suruculer" OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 33355)
-- Name: Suruculer_surucuID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Suruculer_surucuID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Suruculer_surucuID_seq" OWNER TO postgres;

--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 219
-- Name: Suruculer_surucuID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Suruculer_surucuID_seq" OWNED BY public."Suruculer"."surucuID";


--
-- TOC entry 224 (class 1259 OID 33374)
-- Name: Yolcular; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Yolcular" (
    "yolcuID" integer NOT NULL,
    ad character varying,
    soyad character varying,
    "telefonNO" character varying(11),
    email character varying
);


ALTER TABLE public."Yolcular" OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 33373)
-- Name: Yolcular_yolcuID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Yolcular_yolcuID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Yolcular_yolcuID_seq" OWNER TO postgres;

--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 223
-- Name: Yolcular_yolcuID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Yolcular_yolcuID_seq" OWNED BY public."Yolcular"."yolcuID";


--
-- TOC entry 4790 (class 2604 OID 33458)
-- Name: AracBakim bakimID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AracBakim" ALTER COLUMN "bakimID" SET DEFAULT nextval('public."AracBakim_bakimID_seq"'::regclass);


--
-- TOC entry 4789 (class 2604 OID 33449)
-- Name: AracModelleri aracModelID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AracModelleri" ALTER COLUMN "aracModelID" SET DEFAULT nextval('public."AracModelleri_aracModelID_seq"'::regclass);


--
-- TOC entry 4784 (class 2604 OID 33352)
-- Name: Araclar aracID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Araclar" ALTER COLUMN "aracID" SET DEFAULT nextval('public."Araclar_aracID_seq"'::regclass);


--
-- TOC entry 4795 (class 2604 OID 33526)
-- Name: Biletler biletID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Biletler" ALTER COLUMN "biletID" SET DEFAULT nextval('public."Biletler_biletID_seq"'::regclass);


--
-- TOC entry 4793 (class 2604 OID 33493)
-- Name: DurakYorumlari yorumID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DurakYorumlari" ALTER COLUMN "yorumID" SET DEFAULT nextval('public."DurakYorumlari_yorumID_seq"'::regclass);


--
-- TOC entry 4792 (class 2604 OID 33484)
-- Name: Duraklar durakID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Duraklar" ALTER COLUMN "durakID" SET DEFAULT nextval('public."Duraklar_durakID_seq"'::regclass);


--
-- TOC entry 4786 (class 2604 OID 33368)
-- Name: Guzergahlar guzergahID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Guzergahlar" ALTER COLUMN "guzergahID" SET DEFAULT nextval('public."Guzergahlar_guzergahID_seq"'::regclass);


--
-- TOC entry 4797 (class 2604 OID 33554)
-- Name: Odemeler odemeID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Odemeler" ALTER COLUMN "odemeID" SET DEFAULT nextval('public."Odemeler_odemeID_seq"'::regclass);


--
-- TOC entry 4796 (class 2604 OID 33545)
-- Name: Promosyonlar promosyonID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Promosyonlar" ALTER COLUMN "promosyonID" SET DEFAULT nextval('public."Promosyonlar_promosyonID_seq"'::regclass);


--
-- TOC entry 4788 (class 2604 OID 33430)
-- Name: Seferler seferID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seferler" ALTER COLUMN "seferID" SET DEFAULT nextval('public."Seferler_seferID_seq"'::regclass);


--
-- TOC entry 4794 (class 2604 OID 33512)
-- Name: Sikayetler sikayetID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sikayetler" ALTER COLUMN "sikayetID" SET DEFAULT nextval('public."Sikayetler_sikayetID_seq"'::regclass);


--
-- TOC entry 4791 (class 2604 OID 33472)
-- Name: SurucuPuani puanID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SurucuPuani" ALTER COLUMN "puanID" SET DEFAULT nextval('public."SurucuPuani_puanID_seq"'::regclass);


--
-- TOC entry 4785 (class 2604 OID 33359)
-- Name: Suruculer surucuID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Suruculer" ALTER COLUMN "surucuID" SET DEFAULT nextval('public."Suruculer_surucuID_seq"'::regclass);


--
-- TOC entry 4787 (class 2604 OID 33377)
-- Name: Yolcular yolcuID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Yolcular" ALTER COLUMN "yolcuID" SET DEFAULT nextval('public."Yolcular_yolcuID_seq"'::regclass);


--
-- TOC entry 5014 (class 0 OID 33455)
-- Dependencies: 234
-- Data for Name: AracBakim; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."AracBakim" ("bakimID", "aracID", "bakimTarihi", detaylar) FROM stdin;
\.


--
-- TOC entry 5012 (class 0 OID 33446)
-- Dependencies: 232
-- Data for Name: AracModelleri; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."AracModelleri" ("aracModelID", isim, ozellikler) FROM stdin;
1	Mercedes-Benz Travego	Konforlu, Geniş Bagaj
2	Volkswagen Crafter	Ekonomik, Yüksek Performans
\.


--
-- TOC entry 4998 (class 0 OID 33349)
-- Dependencies: 218
-- Data for Name: Araclar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Araclar" ("aracID", "plakaNO", kapasite, "bakimDurumu", "aracKategorisi") FROM stdin;
7	34ABC123	45	t	Otobus
8	35XYZ456	30	f	Minibus
3	\N	\N	\N	\N
1	\N	\N	\N	\N
2	\N	\N	\N	\N
9	34ABC123	40	t	\N
10	56yui78	89	f	\N
\.


--
-- TOC entry 5024 (class 0 OID 33523)
-- Dependencies: 244
-- Data for Name: Biletler; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Biletler" ("biletID", "seferID", "yolcuID", "biletTutari", "satildigiTarih") FROM stdin;
\.


--
-- TOC entry 5020 (class 0 OID 33490)
-- Dependencies: 240
-- Data for Name: DurakYorumlari; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."DurakYorumlari" ("yorumID", "durakID", "yolcuID", yorum, tarih) FROM stdin;
1	1	1	Durak çok kalabalıktı.	2024-12-21
2	2	2	Gayet düzenli ve temizdi.	2024-12-21
\.


--
-- TOC entry 5018 (class 0 OID 33481)
-- Dependencies: 238
-- Data for Name: Duraklar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Duraklar" ("durakID", isim, konum) FROM stdin;
1	Merkez Durak	41.012, 28.978
2	Terminal Durak	41.015, 28.981
\.


--
-- TOC entry 5002 (class 0 OID 33365)
-- Dependencies: 222
-- Data for Name: Guzergahlar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Guzergahlar" ("guzergahID", isim, baslangic, bitis) FROM stdin;
1	Hat 1	Merkez	Terminal
2	Hat 2	Otogar	Havalimanı
3	Hat 3	Kampüs	Şehir Merkezi
\.


--
-- TOC entry 5008 (class 0 OID 33416)
-- Dependencies: 228
-- Data for Name: MinibusSurucusu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."MinibusSurucusu" ("surucuID", "minibusTecrubesi") FROM stdin;
\.


--
-- TOC entry 5006 (class 0 OID 33394)
-- Dependencies: 226
-- Data for Name: Minibusler; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Minibusler" ("aracID", "minibusTuru") FROM stdin;
3	Dolmuş
2	Servis
\.


--
-- TOC entry 5028 (class 0 OID 33551)
-- Dependencies: 248
-- Data for Name: Odemeler; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Odemeler" ("odemeID", "biletID", "odemeTarihi", tutar) FROM stdin;
\.


--
-- TOC entry 5007 (class 0 OID 33406)
-- Dependencies: 227
-- Data for Name: OtobusSurucusu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."OtobusSurucusu" ("surucuID", "otobusTecrubesi") FROM stdin;
\.


--
-- TOC entry 5005 (class 0 OID 33382)
-- Dependencies: 225
-- Data for Name: Otobusler; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Otobusler" ("aracID", "otobusTuru") FROM stdin;
1	Şehirlerarası
2	Şehiriçi
\.


--
-- TOC entry 5026 (class 0 OID 33542)
-- Dependencies: 246
-- Data for Name: Promosyonlar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Promosyonlar" ("promosyonID", isim, "indirimOrani", "gecerlilikTarihi") FROM stdin;
1	Yeni Yıl Kampanyası	10.00	2024-12-31
2	Hafta Sonu Fırsatı	15.00	2024-12-25
\.


--
-- TOC entry 5010 (class 0 OID 33427)
-- Dependencies: 230
-- Data for Name: Seferler; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Seferler" ("seferID", "aracID", "surucuID", guzergah, tarih, saat) FROM stdin;
\.


--
-- TOC entry 5022 (class 0 OID 33509)
-- Dependencies: 242
-- Data for Name: Sikayetler; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Sikayetler" ("sikayetID", "yolcuID", konu, detay, tarih) FROM stdin;
1	1	Geç Kalkan Araç	Otobüs 15 dakika geç kalktı.	2024-12-21
2	2	Kaptanın Davranışı	Sürücü çok kaba davrandı.	2024-12-21
\.


--
-- TOC entry 5016 (class 0 OID 33469)
-- Dependencies: 236
-- Data for Name: SurucuPuani; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."SurucuPuani" ("puanID", "surucuID", puan, tarih) FROM stdin;
\.


--
-- TOC entry 5000 (class 0 OID 33356)
-- Dependencies: 220
-- Data for Name: Suruculer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Suruculer" ("surucuID", ad, soyad, "ehliyetTipi", "surucuKategorisi") FROM stdin;
4	Ali	Yılmaz	B	Otobus Surucusu
5	Veli	Demir	D	Minibus Surucusu
\.


--
-- TOC entry 5004 (class 0 OID 33374)
-- Dependencies: 224
-- Data for Name: Yolcular; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Yolcular" ("yolcuID", ad, soyad, "telefonNO", email) FROM stdin;
1	Fatma	Çelik	05551234567	fatma.celik@example.com
2	Can	Aydın	05341234567	can.aydin@example.com
3	Zeynep	Taş	05431234567	zeynep.tas@example.com
\.


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 233
-- Name: AracBakim_bakimID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."AracBakim_bakimID_seq"', 2, true);


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 231
-- Name: AracModelleri_aracModelID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."AracModelleri_aracModelID_seq"', 2, true);


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 217
-- Name: Araclar_aracID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Araclar_aracID_seq"', 10, true);


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 243
-- Name: Biletler_biletID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Biletler_biletID_seq"', 2, true);


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 239
-- Name: DurakYorumlari_yorumID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."DurakYorumlari_yorumID_seq"', 2, true);


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 237
-- Name: Duraklar_durakID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Duraklar_durakID_seq"', 2, true);


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 221
-- Name: Guzergahlar_guzergahID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Guzergahlar_guzergahID_seq"', 3, true);


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 247
-- Name: Odemeler_odemeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Odemeler_odemeID_seq"', 2, true);


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 245
-- Name: Promosyonlar_promosyonID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Promosyonlar_promosyonID_seq"', 2, true);


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 229
-- Name: Seferler_seferID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Seferler_seferID_seq"', 3, true);


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 241
-- Name: Sikayetler_sikayetID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Sikayetler_sikayetID_seq"', 2, true);


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 235
-- Name: SurucuPuani_puanID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."SurucuPuani_puanID_seq"', 3, true);


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 219
-- Name: Suruculer_surucuID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Suruculer_surucuID_seq"', 5, true);


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 223
-- Name: Yolcular_yolcuID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Yolcular_yolcuID_seq"', 3, true);


--
-- TOC entry 4819 (class 2606 OID 33462)
-- Name: AracBakim AracBakim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AracBakim"
    ADD CONSTRAINT "AracBakim_pkey" PRIMARY KEY ("bakimID");


--
-- TOC entry 4817 (class 2606 OID 33453)
-- Name: AracModelleri AracModelleri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AracModelleri"
    ADD CONSTRAINT "AracModelleri_pkey" PRIMARY KEY ("aracModelID");


--
-- TOC entry 4799 (class 2606 OID 33354)
-- Name: Araclar Araclar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Araclar"
    ADD CONSTRAINT "Araclar_pkey" PRIMARY KEY ("aracID");


--
-- TOC entry 4829 (class 2606 OID 33530)
-- Name: Biletler Biletler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Biletler"
    ADD CONSTRAINT "Biletler_pkey" PRIMARY KEY ("biletID");


--
-- TOC entry 4825 (class 2606 OID 33497)
-- Name: DurakYorumlari DurakYorumlari_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DurakYorumlari"
    ADD CONSTRAINT "DurakYorumlari_pkey" PRIMARY KEY ("yorumID");


--
-- TOC entry 4823 (class 2606 OID 33488)
-- Name: Duraklar Duraklar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Duraklar"
    ADD CONSTRAINT "Duraklar_pkey" PRIMARY KEY ("durakID");


--
-- TOC entry 4803 (class 2606 OID 33372)
-- Name: Guzergahlar Guzergahlar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Guzergahlar"
    ADD CONSTRAINT "Guzergahlar_pkey" PRIMARY KEY ("guzergahID");


--
-- TOC entry 4813 (class 2606 OID 33420)
-- Name: MinibusSurucusu MinibusSurucusu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MinibusSurucusu"
    ADD CONSTRAINT "MinibusSurucusu_pkey" PRIMARY KEY ("surucuID");


--
-- TOC entry 4809 (class 2606 OID 33400)
-- Name: Minibusler Minibusler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Minibusler"
    ADD CONSTRAINT "Minibusler_pkey" PRIMARY KEY ("aracID");


--
-- TOC entry 4833 (class 2606 OID 33558)
-- Name: Odemeler Odemeler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Odemeler"
    ADD CONSTRAINT "Odemeler_pkey" PRIMARY KEY ("odemeID");


--
-- TOC entry 4811 (class 2606 OID 33410)
-- Name: OtobusSurucusu OtobusSurucusu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OtobusSurucusu"
    ADD CONSTRAINT "OtobusSurucusu_pkey" PRIMARY KEY ("surucuID");


--
-- TOC entry 4807 (class 2606 OID 33388)
-- Name: Otobusler Otobusler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Otobusler"
    ADD CONSTRAINT "Otobusler_pkey" PRIMARY KEY ("aracID");


--
-- TOC entry 4831 (class 2606 OID 33549)
-- Name: Promosyonlar Promosyonlar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Promosyonlar"
    ADD CONSTRAINT "Promosyonlar_pkey" PRIMARY KEY ("promosyonID");


--
-- TOC entry 4815 (class 2606 OID 33434)
-- Name: Seferler Seferler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seferler"
    ADD CONSTRAINT "Seferler_pkey" PRIMARY KEY ("seferID");


--
-- TOC entry 4827 (class 2606 OID 33516)
-- Name: Sikayetler Sikayetler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sikayetler"
    ADD CONSTRAINT "Sikayetler_pkey" PRIMARY KEY ("sikayetID");


--
-- TOC entry 4821 (class 2606 OID 33474)
-- Name: SurucuPuani SurucuPuani_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SurucuPuani"
    ADD CONSTRAINT "SurucuPuani_pkey" PRIMARY KEY ("puanID");


--
-- TOC entry 4801 (class 2606 OID 33363)
-- Name: Suruculer Suruculer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Suruculer"
    ADD CONSTRAINT "Suruculer_pkey" PRIMARY KEY ("surucuID");


--
-- TOC entry 4805 (class 2606 OID 33381)
-- Name: Yolcular Yolcular_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Yolcular"
    ADD CONSTRAINT "Yolcular_pkey" PRIMARY KEY ("yolcuID");


--
-- TOC entry 4849 (class 2620 OID 33574)
-- Name: AracBakim bakimGuncellemeTrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "bakimGuncellemeTrigger" AFTER INSERT ON public."AracBakim" FOR EACH ROW EXECUTE FUNCTION public."bakimDurumuGuncelle"();


--
-- TOC entry 4848 (class 2620 OID 33576)
-- Name: Seferler kAzaltTrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "kAzaltTrigger" AFTER INSERT ON public."Seferler" FOR EACH ROW EXECUTE FUNCTION public."kapasiteAzalt"();


--
-- TOC entry 4851 (class 2620 OID 33580)
-- Name: Sikayetler sTarihiGuncelle; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "sTarihiGuncelle" AFTER INSERT ON public."Sikayetler" FOR EACH ROW EXECUTE FUNCTION public."sikayetTarihiGuncelle"();


--
-- TOC entry 4850 (class 2620 OID 33578)
-- Name: DurakYorumlari yTarihiGuncelleTrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "yTarihiGuncelleTrigger" AFTER INSERT ON public."DurakYorumlari" FOR EACH ROW EXECUTE FUNCTION public."yorumTarihiGuncelle"();


--
-- TOC entry 4834 (class 2606 OID 33389)
-- Name: Otobusler fkAracID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Otobusler"
    ADD CONSTRAINT "fkAracID" FOREIGN KEY ("aracID") REFERENCES public."Araclar"("aracID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4835 (class 2606 OID 33401)
-- Name: Minibusler fkAracID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Minibusler"
    ADD CONSTRAINT "fkAracID" FOREIGN KEY ("aracID") REFERENCES public."Araclar"("aracID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4838 (class 2606 OID 33435)
-- Name: Seferler fkAracID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seferler"
    ADD CONSTRAINT "fkAracID" FOREIGN KEY ("aracID") REFERENCES public."Araclar"("aracID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4840 (class 2606 OID 33463)
-- Name: AracBakim fkAracID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AracBakim"
    ADD CONSTRAINT "fkAracID" FOREIGN KEY ("aracID") REFERENCES public."Araclar"("aracID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4847 (class 2606 OID 33559)
-- Name: Odemeler fkBiletID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Odemeler"
    ADD CONSTRAINT "fkBiletID" FOREIGN KEY ("biletID") REFERENCES public."Biletler"("biletID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4842 (class 2606 OID 33498)
-- Name: DurakYorumlari fkDurakID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DurakYorumlari"
    ADD CONSTRAINT "fkDurakID" FOREIGN KEY ("durakID") REFERENCES public."Duraklar"("durakID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4845 (class 2606 OID 33531)
-- Name: Biletler fkSeferID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Biletler"
    ADD CONSTRAINT "fkSeferID" FOREIGN KEY ("seferID") REFERENCES public."Seferler"("seferID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4836 (class 2606 OID 33411)
-- Name: OtobusSurucusu fkSurucuID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OtobusSurucusu"
    ADD CONSTRAINT "fkSurucuID" FOREIGN KEY ("surucuID") REFERENCES public."Suruculer"("surucuID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4837 (class 2606 OID 33421)
-- Name: MinibusSurucusu fkSurucuID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MinibusSurucusu"
    ADD CONSTRAINT "fkSurucuID" FOREIGN KEY ("surucuID") REFERENCES public."Suruculer"("surucuID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4839 (class 2606 OID 33440)
-- Name: Seferler fkSurucuID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seferler"
    ADD CONSTRAINT "fkSurucuID" FOREIGN KEY ("surucuID") REFERENCES public."Araclar"("aracID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4841 (class 2606 OID 33475)
-- Name: SurucuPuani fkSurucuID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SurucuPuani"
    ADD CONSTRAINT "fkSurucuID" FOREIGN KEY ("surucuID") REFERENCES public."Suruculer"("surucuID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4843 (class 2606 OID 33503)
-- Name: DurakYorumlari fkYolcuID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DurakYorumlari"
    ADD CONSTRAINT "fkYolcuID" FOREIGN KEY ("yolcuID") REFERENCES public."Yolcular"("yolcuID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4844 (class 2606 OID 33517)
-- Name: Sikayetler fkYolcuID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sikayetler"
    ADD CONSTRAINT "fkYolcuID" FOREIGN KEY ("yolcuID") REFERENCES public."Yolcular"("yolcuID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4846 (class 2606 OID 33536)
-- Name: Biletler fkYolcuID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Biletler"
    ADD CONSTRAINT "fkYolcuID" FOREIGN KEY ("yolcuID") REFERENCES public."Yolcular"("yolcuID") ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2024-12-23 01:08:06

--
-- PostgreSQL database dump complete
--

