-- 1. Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko). W tabeli mogą być dodatkowe kolumny, 
--    które uznasz za niezbędne.
CREATE TABLE pracownik (
	id INT PRIMARY KEY AUTO_INCREMENT,
    imie VARCHAR(20) NOT NULL,
    nazwisko VARCHAR(20) NOT NULL,
    wyplata DECIMAL(10,2) NOT NULL,
    data_urodzenia DATE NOT NULL,
    stanowisko VARCHAR(40) NOT NULL
);

-- 2. Wstawia do tabeli co najmniej 6 pracowników
INSERT INTO pracownik
    (imie, nazwisko, wyplata, data_urodzenia, stanowisko)
VALUES
    ('Tomasz', 'Jaskowski', 12050.41, '1983-05-01', 'Menadżer'),
    ('Wociech', 'Karlik', 3525.41, '1995-07-03', 'Pracownik produkcji'),
    ('Aleksandra', 'Paluch', 3525.41, '1993-02-11', 'Pracownik produkcji'),
    ('Jan', 'Idzior', 5211, '1982-12-24', 'Kierownik'),
    ('Anna', 'Ochman', 4021.50, '1987-06-21', 'Technolog'),
    ('Iwona', 'Trzaskowska', 3825.41, '1981-10-01', 'Referent');

-- 3. Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku
SELECT imie, nazwisko
	FROM pracownik
    ORDER BY nazwisko ASC;

-- 4. Pobiera pracowników na wybranym stanowisku
SELECT imie, nazwisko, stanowisko
	FROM pracownik
    WHERE stanowisko = 'Pracownik produkcji';

-- 5. Pobiera pracowników, którzy mają co najmniej 30 lat
SELECT *
	FROM pracownik
    WHERE data_urodzenia <= DATE_SUB(CURDATE(), INTERVAL 30 YEAR);

-- 6. Zwiększa wypłatę pracowników na wybranym stanowisku o 10%
SET SQL_SAFE_UPDATES = 0;
UPDATE pracownik 
	SET wyplata = wyplata * 1.1
    WHERE stanowisko = 'Pracownik produkcji';
SET SQL_SAFE_UPDATES = 1;

-- 7. Usuwa najmłodszego pracownika
SET SQL_SAFE_UPDATES = 0;    
DELETE 
	FROM pracownik 
    WHERE data_urodzenia = (
		SELECT DISTINCT MAX(data_urodzenia)
		FROM (SELECT * FROM pracownik) alias
    ); 
SET SQL_SAFE_UPDATES = 1; 

-- 8. Usuwa tabelę pracownik
DROP TABLE IF EXISTS pracownik;

-- 9. Tworzy tabelę stanowisko (nazwa stanowiska, opis, wypłata na danym stanowisku)
CREATE TABLE stanowisko (
	stanowisko_id INT PRIMARY KEY AUTO_INCREMENT,
    nazwa VARCHAR(40) NOT NULL UNIQUE,
    opis VARCHAR(100) NOT NULL,
    wyplata DECIMAL(10,2) NOT NULL
);

-- 10. Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)
CREATE TABLE adres (
	adres_id INT PRIMARY KEY AUTO_INCREMENT,
    ulica_numer_lokalu VARCHAR(50) NOT NULL,
    kod_pocztowy VARCHAR(6) NOT NULL,
    miejscowosc VARCHAR(20) NOT NULL
);

-- 11. Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres
CREATE TABLE pracownik (
	pracownik_id INT PRIMARY KEY AUTO_INCREMENT,
    imie VARCHAR(20) NOT NULL,
    nazwisko VARCHAR(20) NOT NULL,
    adres_id CHAR(4) NOT NULL,
    stanowisko_id CHAR(4) NOT NULL
);

-- 12. Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)
INSERT INTO stanowisko
    (nazwa, opis, wyplata)
VALUES
    ('Menadżer', 'Menadżer produkcji', 8000),
    ('Pracownik produkcji', 'Wykonuje montaż główny', 3200.25),
    ('Kierownik', 'Zarządza wydziałem technologicznym', 5000),
    ('Technolog', 'Wykonywanie dokumentacji produkcyjnej', 4500),
    ('Referent', 'Kontakt z biurem rachunkowym', 3200);
    
INSERT INTO adres
    (ulica_numer_lokalu, kod_pocztowy, miejscowosc)
VALUES
    ('Piastowska 33A', '44-120', 'Zabrze'),
    ('Dworcowa 25', '10-100', 'Warszawa'),
    ('Powstańsów Śl. 22', '34-521', 'Ząb'),
    ('Toszecka 185', '44-100', 'Gliwice'),
    ('Chodzowska 1', '55-200', 'Olkusz'),
    ('Panewnicka 2', '44-100', 'Gliwice');

INSERT INTO pracownik
	(imie, nazwisko, adres_id, stanowisko_id)
VALUES
    ('Tomasz', 'Jaskowski', 1, 1),
    ('Wociech', 'Karlik', 3, 2),
    ('Aleksandra', 'Paluch', 2, 3),
    ('Jan', 'Idzior', 6, 2 ),
    ('Anna', 'Ochman', 4, 4),
    ('Iwona', 'Trzaskowska', 5, 5);

-- 13. Oblicza sumę wypłat dla wszystkich pracowników w firmie
SELECT SUM(st.wyplata) as 'Suma wypłat w firmie'
FROM pracownik pr
JOIN stanowisko st ON pr.stanowisko_id = st.stanowisko_id;

-- 14. Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał 
--     sens dla Twoich danych testowych)
SELECT imie, nazwisko, kod_pocztowy, miejscowosc, ulica_numer_lokalu
FROM pracownik pr
JOIN adres ad ON pr.adres_id = ad.adres_id
WHERE ad.kod_pocztowy = '44-100';