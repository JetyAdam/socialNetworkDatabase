/*
 file: xosine00_xjetma02.sql
 authors: Pavel Osinek (xosine00), Adam Jetmar(xjetma02)
 date: 03.04.2022
 description: Basic database structure for IDS project (part 2)
 */

/* ------------------------------ Smazání tabulek ------------------------------ */

DROP TABLE misto CASCADE CONSTRAINTS;
DROP TABLE uzivatel CASCADE CONSTRAINTS;
DROP TABLE zadost_o_pratelstvi CASCADE CONSTRAINTS;
DROP TABLE pratele CASCADE CONSTRAINTS;
DROP TABLE zakladni_informace CASCADE CONSTRAINTS;
DROP TABLE konverzace CASCADE CONSTRAINTS;
DROP TABLE uzivatel_v_konverzaci CASCADE CONSTRAINTS;
DROP TABLE zprava CASCADE CONSTRAINTS;
DROP TABLE textova_zprava CASCADE CONSTRAINTS;
DROP TABLE zprava_obrazek CASCADE CONSTRAINTS;
DROP TABLE zprava_soubor CASCADE CONSTRAINTS;
DROP TABLE prispevek CASCADE CONSTRAINTS;
DROP TABLE typ_akce CASCADE CONSTRAINTS;
DROP TABLE akce CASCADE CONSTRAINTS;
DROP TABLE ucastnici_akce CASCADE CONSTRAINTS;
DROP TABLE nastaveni_soukromi CASCADE CONSTRAINTS;
DROP TABLE album CASCADE CONSTRAINTS;
DROP TABLE fotografie CASCADE CONSTRAINTS;
DROP TABLE foto_oznaceni CASCADE CONSTRAINTS;
DROP TABLE prispevek_oznaceni CASCADE CONSTRAINTS;

/* ------------------------------ Vytvoření tabulek ------------------------------ */

CREATE TABLE misto
(
    id            NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    mesto         VARCHAR(100)                                                      NOT NULL,
    ulice         VARCHAR(100),
    cislo_popisne NUMBER(5),
    psc           NUMBER(5)
);

CREATE TABLE uzivatel
(
    id       NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    jmeno    VARCHAR(50)                                                       NOT NULL,
    prijmeni VARCHAR(50)                                                       NOT NULL,
    email    VARCHAR(100) UNIQUE                                               NOT NULL,

    constraint chk_email check (email LIKE '%_@__%.__%')
);

CREATE TABLE zadost_o_pratelstvi
(
    id    NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    datum DATE                                                              NOT NULL,
    cas   INTERVAL DAY(0) TO SECOND(0)                                      NOT NULL,
    od    NUMBER                                                            NOT NULL,
    pro   NUMBER                                                            NOT NULL,
    stav  NUMBER(1) DEFAULT 0                                               NOT NULL CHECK (stav >= 0 AND stav <= 1),

    CONSTRAINT od_fk FOREIGN KEY (od) REFERENCES uzivatel (id),
    CONSTRAINT pro_fk FOREIGN KEY (pro) REFERENCES uzivatel (id)
);

CREATE TABLE pratele
(
    id       NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    uzivatel NUMBER                                                            NOT NULL,
    pritel   NUMBER                                                            NOT NULL,
    CONSTRAINT uzivatel_pr_fk FOREIGN KEY (uzivatel) REFERENCES uzivatel (id),
    CONSTRAINT pritel_fk FOREIGN KEY (pritel) REFERENCES uzivatel (id)
);

CREATE TABLE zakladni_informace
(
    id       NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    povolani VARCHAR(100),
    vzdelani VARCHAR(100),
    email2   VARCHAR(100),
    telefon  NUMERIC,
    uzivatel NUMBER                                                            NOT NULL,

    CONSTRAINT uzivatel_fk FOREIGN KEY (uzivatel) REFERENCES uzivatel (id),
    CONSTRAINT chk_email2 CHECK (email2 LIKE '%_@__%.__%'),
    CONSTRAINT chk_telefon CHECK (telefon BETWEEN '100000000' AND '999999999')
);

CREATE TABLE konverzace
(
    id         NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    nazev      VARCHAR(100),
    zakladatel NUMBER                                                            NOT NULL,

    CONSTRAINT zakladatel_fk FOREIGN KEY (zakladatel) REFERENCES uzivatel (id)
);

CREATE TABLE uzivatel_v_konverzaci
(
    id         NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    uzivatel   NUMBER                                                            NOT NULL,
    konverzace NUMBER                                                            NOT NULL,

    CONSTRAINT uzivatel_v_konverzaci_fk FOREIGN KEY (uzivatel) REFERENCES uzivatel (id),
    CONSTRAINT konverzace_fk FOREIGN KEY (konverzace) REFERENCES konverzace (id)
);

CREATE TABLE zprava
(
    id         NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    datum      DATE                                                              NOT NULL,
    cas        INTERVAL DAY(0) TO SECOND(0)                                      NOT NULL,
    misto      NUMBER,
    od         NUMBER                                                            NOT NULL,
    konverzace NUMBER                                                            NOT NULL,

    CONSTRAINT misto_zpravy_fk FOREIGN KEY (misto) REFERENCES misto (id),
    CONSTRAINT zprava_od_fk FOREIGN KEY (od) REFERENCES uzivatel (id),
    CONSTRAINT zprava_v_konverzaci_fk FOREIGN KEY (konverzace) REFERENCES konverzace (id)
);

CREATE TABLE textova_zprava
(
    id     NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    zprava NUMBER                                                            NOT NULL,
    obsah  VARCHAR(1000)                                                     NOT NULL,
    CONSTRAINT zprava_text_fk FOREIGN KEY (zprava) REFERENCES zprava (id)
);

CREATE TABLE zprava_obrazek
(
    id       NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    zprava   NUMBER                                                            NOT NULL,
    nazev    VARCHAR(100)                                                      NOT NULL,
    velikost NUMBER                                                            NOT NULL,
    vyska    NUMBER                                                            NOT NULL,
    sirka    NUMBER                                                            NOT NULL,
    cesta    VARCHAR(100)                                                      NOT NULL,
    CONSTRAINT zprava_obrazek_fk FOREIGN KEY (zprava) REFERENCES zprava (id)
);

CREATE TABLE zprava_soubor
(
    id       NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    zprava   NUMBER                                                            NOT NULL,
    nazev    VARCHAR(100)                                                      NOT NULL,
    velikost NUMBER                                                            NOT NULL,
    cesta    VARCHAR(100)                                                      NOT NULL,
    CONSTRAINT zprava_soubor_fk FOREIGN KEY (zprava) REFERENCES zprava (id)
);

CREATE TABLE prispevek
(
    id    NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    obsah VARCHAR(500)                                                      NOT NULL,
    datum DATE                                                              NOT NULL,
    cas   INTERVAL DAY(0) TO SECOND(0)                                      NOT NULL,
    misto NUMBER,
    autor NUMBER                                                            NOT NULL,

    CONSTRAINT misto_prispevku_fk FOREIGN KEY (misto) REFERENCES misto (id),
    CONSTRAINT prispevek_od_fk FOREIGN KEY (autor) REFERENCES uzivatel (id)
);

CREATE TABLE typ_akce
(
    id    NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    nazev VARCHAR(100)
);

CREATE TABLE akce
(
    id        NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    popisek   VARCHAR(500),
    datum     DATE                                                              NOT NULL,
    cas       INTERVAL DAY(0) TO SECOND(0)                                      NOT NULL,
    misto     NUMBER,
    typ_akce  NUMBER                                                            NOT NULL,
    poradatel NUMBER                                                            NOT NULL,
    kapacita  NUMBER,

    CONSTRAINT misto_akce_fk FOREIGN KEY (misto) REFERENCES misto (id),
    CONSTRAINT poradatel_akce_fk FOREIGN KEY (poradatel) REFERENCES uzivatel (id),
    CONSTRAINT typ_akce_fk FOREIGN KEY (typ_akce) REFERENCES typ_akce (id)
);

CREATE TABLE ucastnici_akce
(
    id       NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    uzivatel NUMBER                                                            NOT NULL,
    akce     NUMBER                                                            NOT NULL,

    CONSTRAINT ucastnik_fk FOREIGN KEY (uzivatel) REFERENCES uzivatel (id),
    CONSTRAINT akce_fk FOREIGN KEY (akce) REFERENCES akce (id)
);

CREATE TABLE nastaveni_soukromi
(
    id    NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    nazev VARCHAR(100)                                                      NOT NULL
);

CREATE TABLE album
(
    id                 NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    nazev              VARCHAR(100)                                                      NOT NULL,
    popis              VARCHAR(500),
    nastaveni_soukromi NUMBER,
    uzivatel           NUMBER,

    CONSTRAINT nastaveni_soukromi_fk FOREIGN KEY (nastaveni_soukromi) REFERENCES nastaveni_soukromi (id),
    CONSTRAINT vytvoril_fk FOREIGN KEY (uzivatel) REFERENCES uzivatel (id)
);

CREATE TABLE fotografie
(
    id      NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    datum   DATE                                                              NOT NULL,
    cas     INTERVAL DAY(0) TO SECOND(0)                                      NOT NULL,
    misto   NUMBER,
    titulni NUMBER(1) DEFAULT 0 CHECK (titulni >= 0 AND titulni <= 1),
    akce    NUMBER,
    od      NUMBER                                                            NOT NULL,
    album   NUMBER,
    cesta   VARCHAR(100)                                                      NOT NULL,

    CONSTRAINT misto_fotografie_fk FOREIGN KEY (misto) REFERENCES misto (id),
    CONSTRAINT akce_fotografie_fk FOREIGN KEY (akce) REFERENCES akce (id),
    CONSTRAINT fotografie_od_fk FOREIGN KEY (od) REFERENCES uzivatel (id),
    CONSTRAINT album_fk FOREIGN KEY (album) REFERENCES album (id)
);

CREATE TABLE foto_oznaceni
(
    id         NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    uzivatel   NUMBER                                                            NOT NULL,
    fotografie NUMBER                                                            NOT NULL,

    CONSTRAINT oznaceny_na_foto_fk FOREIGN KEY (uzivatel) REFERENCES uzivatel (id),
    CONSTRAINT fotografie_fk FOREIGN KEY (fotografie) REFERENCES fotografie (id)
);

CREATE TABLE prispevek_oznaceni
(
    id        NUMBER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    uzivatel  NUMBER                                                            NOT NULL,
    prispevek NUMBER                                                            NOT NULL,

    CONSTRAINT oznaceny_v_prispevku_fk FOREIGN KEY (uzivatel) REFERENCES uzivatel (id),
    CONSTRAINT prispevek_fk FOREIGN KEY (prispevek) REFERENCES prispevek (id)
);


/* ------------------------------ Příkazy INSERT ------------------------------ */

/* místo */
INSERT INTO misto(mesto)
VALUES ('Praha');
INSERT INTO misto(mesto, ulice, cislo_popisne, psc)
VALUES ('Plzeň', 'Hřbitovní', 11, 56004);

/* uzivatel */
INSERT INTO uzivatel (jmeno, prijmeni, email)
VALUES ('Pavel', 'Osinek', 'xosine00@vutbr.cz');

INSERT INTO uzivatel (jmeno, prijmeni, email)
VALUES ('Adam', 'Jetmar', 'xjetma02@vutbr.cz');

INSERT INTO uzivatel (jmeno, prijmeni, email)
VALUES ('Petr', 'Šiler', 'petrsiler@vutbr.cz');

INSERT INTO uzivatel (jmeno, prijmeni, email)
VALUES ('Karel', 'Novák', 'kajanovak@vutbr.cz');

INSERT INTO uzivatel (jmeno, prijmeni, email)
VALUES ('Jaroslav', 'Němec', 'jarda@vutbr.cz');

INSERT INTO uzivatel (jmeno, prijmeni, email)
VALUES ('Lukáš', 'Kovář', 'lukyK@vutbr.cz');

/* zadost o pratelstvi */
INSERT INTO zadost_o_pratelstvi(datum, cas, od, pro, stav)
VALUES (TO_DATE('2003/05/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 02:00:00'), 1, 2, 1);
INSERT INTO zadost_o_pratelstvi(datum, cas, od, pro)
VALUES (TO_DATE('2003/05/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+0 14:35:10'), 2, 3);
/* pratele */
INSERT INTO pratele(uzivatel, pritel)
VALUES (2, 3);

/* zakladni informace */
INSERT INTO zakladni_informace(telefon, email2, uzivatel, vzdelani)
VALUES (739564821, 'kaja2@google.com', 2, 'vysokoškolské');
INSERT INTO zakladni_informace(telefon, email2, uzivatel, vzdelani, povolani)
VALUES (739564821, 'kaja2@google.com', 3, 'zakladni', 'programator');
INSERT INTO zakladni_informace(telefon, vzdelani, uzivatel)
VALUES (123456789, 'střední vzdělání', 1);
INSERT INTO zakladni_informace(telefon, povolani, uzivatel)
VALUES (111222333, 'programator', 5);
INSERT INTO zakladni_informace(telefon, povolani, uzivatel)
VALUES (333222111, 'prodavac', 4);

/* konverzace */
INSERT INTO konverzace(nazev, zakladatel)
VALUES ('Skupina 1', 2);
INSERT INTO konverzace(nazev, zakladatel)
VALUES ('Skupina 2', 1);
INSERT INTO konverzace(nazev, zakladatel)
VALUES ('Skupina 3', 5);
INSERT INTO konverzace(nazev, zakladatel)
VALUES ('Skupina 4', 5);


/* uzivatel_v_konverzaci */
INSERT INTO uzivatel_v_konverzaci(uzivatel, konverzace)
VALUES (1, 1);
INSERT INTO uzivatel_v_konverzaci(uzivatel, konverzace)
VALUES (2, 1);
INSERT INTO uzivatel_v_konverzaci(uzivatel, konverzace)
VALUES (3, 2);
INSERT INTO uzivatel_v_konverzaci(uzivatel, konverzace)
VALUES (5, 3);
INSERT INTO uzivatel_v_konverzaci(uzivatel, konverzace)
VALUES (5, 4);

/* zprava */
INSERT INTO zprava(datum, cas, misto, konverzace, od)
VALUES (TO_DATE('2003/05/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 14:00:50'), 2, 1, 1);
INSERT INTO zprava(datum, cas, misto, konverzace, od)
VALUES (TO_DATE('2003/05/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 12:10:19'), 1, 1, 2);
INSERT INTO zprava(datum, cas, misto, konverzace, od)
VALUES (TO_DATE('2003/05/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 18:35:58'), 2, 1, 1);
INSERT INTO zprava(datum, cas, misto, konverzace, od)
VALUES (TO_DATE('2003/05/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 11:12:14'), 1, 2, 3);
INSERT INTO zprava(datum, cas, misto, konverzace, od)
VALUES (TO_DATE('2022/01/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 11:12:14'), 1, 2, 3);
INSERT INTO zprava(datum, cas, misto, konverzace, od)
VALUES (TO_DATE('2022/01/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 11:13:14'), 1, 2, 3);

/* textova zprava */
INSERT INTO textova_zprava(zprava, obsah)
VALUES (1, 'Ahoj Jardo, jak se máš?');

/* zprava obrazek */
INSERT INTO zprava_obrazek(zprava, nazev, velikost, vyska, sirka, cesta)
VALUES (2, 'obrazek.jpg', 192, 1080, 1920, 'obrazky/obrazek.jpg');

/* zprava soubor */
INSERT INTO zprava_soubor(zprava, nazev, velikost, cesta)
VALUES (3, 'dokument.pdf', 1555, 'soubory/dokument.pdf');
INSERT INTO zprava_soubor(zprava, nazev, velikost, cesta)
VALUES (5, 'dokument2.pdf', 555, 'soubory/dokument2.pdf');
INSERT INTO zprava_soubor(zprava, nazev, velikost, cesta)
VALUES (5, 'dokument3.pdf', 2055, 'soubory/dokument3.pdf');

/* prispevek */
INSERT INTO prispevek(obsah, datum, cas, misto, autor)
VALUES ('Můj první příspěvěk...@Jaroslav', TO_DATE('2003/05/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 17:04:05'), 2, 2);

/* typ_akce */
INSERT INTO typ_akce(nazev)
VALUES ('Ostatní');
INSERT INTO typ_akce(nazev)
VALUES ('Společenská akce');
INSERT INTO typ_akce(nazev)
VALUES ('Soukromá akce');
INSERT INTO typ_akce(nazev)
VALUES ('Firemní akce');
INSERT INTO typ_akce(nazev)
VALUES ('Vzdělávací akce');

/* akce */
INSERT INTO akce(popisek, datum, cas, misto, typ_akce, poradatel)
VALUES ('Koncert skupiny XYZ', TO_DATE('2003/05/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 12:40:00'), 1, 2, 2);
INSERT INTO akce(popisek, datum, cas, misto, typ_akce, poradatel, kapacita)
VALUES ('FIT festival', TO_DATE('2022/04/30', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 13:40:00'), 1, 2, 1, 250);
INSERT INTO akce(popisek, datum, cas, misto, typ_akce, poradatel, kapacita)
VALUES ('Oslava narozenin Jardy', TO_DATE('2021/04/30', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 18:00:00'), 2, 3, 5, 5);

/* ucastnici_akce */
INSERT INTO ucastnici_akce(uzivatel, akce)
VALUES (1, 1);
INSERT INTO ucastnici_akce(uzivatel, akce)
VALUES (2, 1);
INSERT INTO ucastnici_akce(uzivatel, akce)
VALUES (3, 2);
INSERT INTO ucastnici_akce(uzivatel, akce)
VALUES (1, 3);
INSERT INTO ucastnici_akce(uzivatel, akce)
VALUES (4, 3);
INSERT INTO ucastnici_akce(uzivatel, akce)
VALUES (5, 3);
INSERT INTO ucastnici_akce(uzivatel, akce)
VALUES (2, 3);

/* nastaveni_soukromi */
INSERT INTO nastaveni_soukromi(nazev)
VALUES ('Veřejné');
INSERT INTO nastaveni_soukromi(nazev)
VALUES ('Soukromé');
INSERT INTO nastaveni_soukromi(nazev)
VALUES ('Pouze přátelé');

/* album */
INSERT INTO album(nazev, popis, nastaveni_soukromi, uzivatel)
VALUES ('Soukromé album', 'Fotky pouze pro mě', 2, 1);
INSERT INTO album(nazev, popis, nastaveni_soukromi, uzivatel)
VALUES ('Veřejné album', 'Fotky viditelné pro všechny uživatele', 2, 1);

/* fotografie */
INSERT INTO fotografie(datum, cas, misto, titulni, akce, od, album, cesta)
VALUES (TO_DATE('2003/05/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 17:20:02'), 2, 1, 1, 1, 2,
        'D:/foto1.jpg');
INSERT INTO fotografie(datum, cas, misto, od, album, cesta)
VALUES (TO_DATE('2003/05/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 22:38:10'), 1, 1, 1,
        'D:/foto2.png');
INSERT INTO fotografie(datum, cas, misto, titulni, akce, od, album, cesta)
VALUES (TO_DATE('2003/02/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 17:20:02'), 2, 0, 1, 1, 2, 'D:/foto3.jpg');
INSERT INTO fotografie(datum, cas, misto, titulni, akce, od, album, cesta)
VALUES (TO_DATE('2003/06/12', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 17:20:02'), 2, 0, 2, 1, 2, 'D:/foto4.jpg');

/* foto oznaceni */
INSERT INTO foto_oznaceni(uzivatel, fotografie)
VALUES (1, 1);
INSERT INTO foto_oznaceni(uzivatel, fotografie)
VALUES (1, 3);
INSERT INTO foto_oznaceni(uzivatel, fotografie)
VALUES (2, 1);
INSERT INTO foto_oznaceni(uzivatel, fotografie)
VALUES (3, 2);

/* prispevek oznaceni */
INSERT INTO prispevek_oznaceni(uzivatel, prispevek)
VALUES (3, 1);

/* ------------------------------ Dotazy SELECT ------------------------------ */

/* Dotazy se 2 tabulkami */
/* Jake prispevky publikoval uzivatel */
SELECT jmeno, prijmeni, obsah
FROM uzivatel U,
     prispevek P
WHERE U.id = P.autor;

/* Vybere uzivatele, kteri maji na svem profilu informaci o jejich vzdelani */
SELECT U.jmeno, U.prijmeni, I.vzdelani
FROM uzivatel U,
     zakladni_informace I
WHERE U.id = I.uzivatel
  AND I.vzdelani IS NOT NULL;

/* 3 tabulky */
/* Kteri uzivatele se zucastnili akce 'Koncert skupiny XYZ' */
SELECT CONCAT(CONCAT(U.jmeno, ' '), U.prijmeni) jmeno
FROM uzivatel U,
     akce A,
     ucastnici_akce UA
WHERE U.id = UA.uzivatel
  AND UA.akce = A.id
  AND A.popisek LIKE 'Koncert skupiny XYZ';

/* Na jakých fotkách jsou uzivatele oznaceni */
SELECT CONCAT(CONCAT(U.jmeno, ' '), U.prijmeni) jmeno, F.cesta foto
FROM uzivatel U,
     foto_oznaceni FO,
     fotografie F
WHERE U.id = FO.uzivatel
  AND FO.fotografie = F.id
ORDER BY jmeno;

/* Dotazy s GROUP BY a agregacni funkci */
/* kolik fotek patri do daneho alba */
SELECT A.nazev, COUNT(*) AS pocet_fotek_v_albumu
FROM album A,
     fotografie F
WHERE A.id = F.album
GROUP BY A.nazev;

/* Kolik fotek bylo porizeno na akci */
SELECT popisek, COUNT(*) pocet_fotek
FROM akce A,
     fotografie F
WHERE A.id = F.akce
GROUP BY popisek;

/* Predikat EXISTS */
/* Kteri uzivatele maji na profilu informaci o vzdelani a nemaji informaci o povolani */
SELECT DISTINCT jmeno, prijmeni
FROM uzivatel U,
     zakladni_informace I
WHERE U.id = I.uzivatel
  AND vzdelani IS NOT NULL
  AND EXISTS(SELECT * FROM zakladni_informace I WHERE U.id = I.uzivatel AND povolani IS NULL);

/* Predikat IN */
/* Kteri uzivatele zalozili alespon jednu konverzaci */
SELECT U.jmeno, U.prijmeni
FROM uzivatel U
WHERE U.id IN (SELECT zakladatel FROM konverzace);

/* ------------------------------ POKROČILÉ OBJEKTY SCHÉMATU DATABÁZE ------------------------------ */

/* Triggery */

/* trigger - hlídá, že do konverzace může psát pouze uživatel, který je v dané konverzaci */
CREATE OR REPLACE TRIGGER trigger_valid_conversation
    BEFORE INSERT
    ON Zprava
    FOR EACH ROW

DECLARE
    cnt NUMBER;
    USER_NOT_IN_CHAT EXCEPTION;
    err_code NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO cnt
    FROM uzivatel_v_konverzaci UVK
    WHERE UVK.uzivatel = :NEW.od
      AND UVK.konverzace = :NEW.konverzace;
    IF (cnt = 0)
    THEN
        RAISE USER_NOT_IN_CHAT;
    END IF;
EXCEPTION
    WHEN USER_NOT_IN_CHAT THEN
        RAISE_APPLICATION_ERROR(-20001, 'Uzivatel neni v konverzaci');
    WHEN OTHERS THEN
        err_code := SQLCODE;
        dbms_output.put_line('Error code:' || err_code);
END trigger_valid_conversation;/

SELECT * FROM uzivatel_v_konverzaci;

/* proběhne */
INSERT INTO zprava(datum, cas, misto, konverzace, od)
VALUES (TO_DATE('2022/01/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 11:13:14'), 1, 4, 5);

/* neproběhne */
INSERT INTO zprava(datum, cas, misto, konverzace, od)
VALUES (TO_DATE('2022/01/03', 'yyyy/mm/dd'), TO_DSINTERVAL('+00 11:13:14'), 1, 4, 1);

/* trigger - hlídá kapacitu na akci */
CREATE OR REPLACE TRIGGER trigger_capacity_check
    BEFORE INSERT ON ucastnici_akce
    REFERENCING new AS new_row
    FOR EACH ROW

DECLARE
    cap akce.kapacita%TYPE;
    cnt NUMBER;
    err_code NUMBER;
    NO_CAPACITY EXCEPTION;

BEGIN
        SELECT kapacita INTO cap FROM akce WHERE id = :new_row.akce_fk;
        SELECT COUNT(*) INTO cnt FROM ucastnici_akce WHERE akce_fk = :new_row.akce_fk;

    IF(cnt IS NOT NULL AND cap IS NOT NULL) THEN
        IF(cnt >= cap) THEN
                RAISE NO_CAPACITY;
        END IF;
    ELSE
        RAISE NO_DATA_FOUND;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'No data found.',true);
    WHEN NO_CAPACITY THEN
        RAISE_APPLICATION_ERROR(-20002, 'Akce je jiz plne obsazena.',true);
    WHEN OTHERS THEN
        err_code := SQLCODE;
        dbms_output.put_line('Error code:' || err_code);
END;/

SELECT * FROM ucastnici_akce;

/* proběhne */
INSERT INTO ucastnici_akce(uzivatel_fk, akce_fk)
VALUES (5, 3);

/* neproběhne */
INSERT INTO ucastnici_akce(uzivatel_fk, akce_fk)
VALUES (6, 3);


/* Procedury */

/* Z kolika procent je naplněná kapacita akcí */
CREATE OR REPLACE PROCEDURE naplnenost_akce AS
    id_akce         akce.popisek%TYPE;
    kapacita_akce   akce.kapacita%TYPE;
    popisek_akce    akce.popisek%TYPE;
    pocet_uzivatelu NUMBER;
    naplnenost_akce NUMBER;
    CURSOR cursor_akce IS SELECT id, popisek, kapacita
                          FROM akce;
BEGIN

    OPEN cursor_akce;

    DBMS_OUTPUT.put_line('Akce   |   Naplněnost');
    DBMS_OUTPUT.put_line('---------------------');

    LOOP
        FETCH cursor_akce INTO id_akce, popisek_akce, kapacita_akce;
        EXIT WHEN cursor_akce%NOTFOUND;

        SELECT COUNT(*) INTO pocet_uzivatelu FROM ucastnici_akce WHERE akce = id_akce;

        IF kapacita_akce IS NULL THEN
            -- pokud je kapacita akce NULL, znamená to, že kapacita je neomezená, naplněnost je tedy 0
            naplnenost_akce := 0;
        ELSE
            BEGIN
                naplnenost_akce := (pocet_uzivatelu / kapacita_akce) * 100;
            EXCEPTION
                WHEN ZERO_DIVIDE THEN
                    DBMS_OUTPUT.put_line('Kapacita akce je nastavena na 0.');
            END;
        END IF;

        DBMS_OUTPUT.put_line(popisek_akce || '   |   ' || naplnenost_akce || ' %');

    END LOOP;
    CLOSE cursor_akce;
END;
/

/* Kolik akcí se účastní daný uživatel */
CREATE OR REPLACE PROCEDURE pocet_akci_uzivatele(id_uzivatele IN NUMBER) AS
    pocet_akci       NUMBER;
    akce_s_uzivatelem NUMBER;
    uzivatel_id             uzivatel.id%TYPE;
    hledany_uzivatel        uzivatel.id%TYPE;
    CURSOR uzivatele IS SELECT uzivatel
                        FROM ucastnici_akce;
BEGIN
    SELECT COUNT(*) INTO pocet_akci FROM akce;
    akce_s_uzivatelem := 0;

    SELECT id INTO hledany_uzivatel FROM uzivatel WHERE id = id_uzivatele;

    OPEN uzivatele;
    LOOP
        FETCH uzivatele INTO uzivatel_id;
        EXIT WHEN uzivatele%NOTFOUND;

        IF uzivatel_id = hledany_uzivatel THEN
            akce_s_uzivatelem := akce_s_uzivatelem + 1;
        END IF;
    END LOOP;
    CLOSE uzivatele;

    DBMS_OUTPUT.PUT_LINE('Uživatel s ID: ' || hledany_uzivatel || ' se účastní ' || akce_s_uzivatelem || ' akcí');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Uzivatel s ID: ' || id_uzivatele || ' neexistuje.');
        END;
END;/

/* Demonstrace procedur */
BEGIN
    pocet_akci_uzivatele(1);
END;

BEGIN
    naplnenost_akce();
END;


/* přístupová práva */
GRANT ALL ON misto TO xjetma02;
GRANT ALL ON uzivatel TO xjetma02;
GRANT ALL ON zadost_o_pratelstvi TO xjetma02;
GRANT ALL ON pratele TO xjetma02;
GRANT ALL ON zakladni_informace TO xjetma02;
GRANT ALL ON konverzace TO xjetma02;
GRANT ALL ON uzivatel_v_konverzaci TO xjetma02;
GRANT ALL ON zprava TO xjetma02;
GRANT ALL ON textova_zprava TO xjetma02;
GRANT ALL ON zprava_obrazek TO xjetma02;
GRANT ALL ON zprava_soubor TO xjetma02;
GRANT ALL ON prispevek TO xjetma02;
GRANT ALL ON typ_akce TO xjetma02;
GRANT ALL ON akce TO xjetma02;
GRANT ALL ON ucastnici_akce TO xjetma02;
GRANT ALL ON nastaveni_soukromi TO xjetma02;
GRANT ALL ON album TO xjetma02;
GRANT ALL ON fotografie TO xjetma02;
GRANT ALL ON foto_oznaceni TO xjetma02;
GRANT ALL ON prispevek_oznaceni TO xjetma02;

GRANT EXECUTE ON pocet_akci_uzivatele TO xjetma02;
GRANT EXECUTE ON naplnenost_akce TO xjetma02;


/* Index */

/* Vybere uzivatele s prijmenim zacinajicim na O, index tomu pomuze, jelikoz je serazeny sestupne a O v druhe polovine abecedy */
CREATE INDEX usersLastName ON uzivatel(prijmeni DESC);
SELECT * FROM uzivatel WHERE prijmeni LIKE 'O%';


/* Explain Plan */

/* kolik fotek patri do daneho albumu (nazev, pocet_fotek_v_albumu) */
/* urychleni - vytvoreni indexu, ktery seskupi album podle nazvu, jelikoz GROUP BY je narocna operace */
EXPLAIN PLAN SET STATEMENT_ID = 'explain_plan' FOR SELECT A.nazev, COUNT(*) AS pocet_fotek_v_albumu FROM album A, fotografie F WHERE A.id=F.album GROUP BY A.nazev;

SELECT PLAN_TABLE_OUTPUT
  FROM TABLE(DBMS_XPLAN.DISPLAY());

/* Rychlejsi Explain Plan */
CREATE INDEX pocet_fotek ON album(nazev);
EXPLAIN PLAN SET STATEMENT_ID = 'explain_plan_faster' FOR SELECT A.nazev, COUNT(*) AS pocet_fotek_v_albumu FROM album A, fotografie F WHERE A.id=F.album GROUP BY A.nazev;

SELECT PLAN_TABLE_OUTPUT
  FROM TABLE(DBMS_XPLAN.DISPLAY());

/*
DROP INDEX pocet_fotek;
DROP INDEX UsersLastName;
DELETE FROM PLAN_TABLE WHERE STATEMENT_ID = 'explain_plan';
DELETE FROM PLAN_TABLE WHERE STATEMENT_ID = 'explain_plan_faster';
*/
