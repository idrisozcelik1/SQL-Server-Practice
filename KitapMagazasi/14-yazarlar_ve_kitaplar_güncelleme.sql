14. Çoktan çoğa ilişki
Bir kitabın birden fazla yazarı olabileceğini varsay.
Mevcut durumda Kitaplar tablosundaki YazarID alanı bunu desteklemez. Tasarımı çoktan çoğa ilişkiyi destekleyecek şekilde değiştir.
Beklenen yeni tablo:
KitapYazarlari
Alan Açıklama
KitapID Kitaplar tablosuna Foreign Key
YazarID Yazarlar tablosuna Foreign Key
YazarSirasi Yazarın kitap üzerindeki sırası
KatkiTuru Yazar, Editör veya Çevirmen


Kurallar:
Aynı yazar aynı kitaba iki kez eklenememeli. (+)
KitapID ve YazarID birlikte Primary Key veya Unique Key olmalı. (+)
Bir kitabın birden fazla yazarı olabilir. 
Bir yazarın birden fazla kitabı olabilir.
Görevler:
Ara tabloyu oluştur. (+)
Mevcut ilişkileri ara tabloya aktar. (+)
Kitaplar.YazarID alanını kaldır. (+)
Birden fazla yazarı olan en az iki kitap ekle. (+)
Kitapları yazarlarıyla birlikte listele. (+)
Her kitabın tüm yazarlarını tek satırda göster. (+)
En fazla ortak kitap yazan yazar ikilisini bul. (+)(?)
Hem yazar hem editör olarak görev alan kişileri listele. (+)

SELECT * FROM Kategoriler;
SELECT * FROM Kitaplar;										--COMPOSIT PRIMARY KEY, AYNI VERİNİN BİRDEN FAZLA KEZ OLUŞTURULMASINI ENGELLER.
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;
SELECT * FROM Sehirler;
SELECT * FROM Ilceler;
SELECT * FROM Adresler;
SELECT * FROM MusteriAdresleri;
SELECT * FROM KitapYazarlari;

CREATE TABLE KitapYazarlari(
Alan VARCHAR(100),
KitapID INT FOREIGN KEY REFERENCES Kitaplar(KitapID),
YazarID INT FOREIGN KEY REFERENCES Yazarlar(YazarID),
YazarSirasi VARCHAR(100),
KatkiTuru VARCHAR(100) CHECK (KatkiTuru IN ('Yazar','Editör','Çevirmen'))
PRIMARY KEY(KitapID,YazarID)
);

--Yanlışlıkla Alan eklemiştim, onu kaldırdım.
ALTER TABLE KitapYazarlari ALTER COLUMN YazarSirasi INT;
ALTER TABLE KitapYazarlari DROP COLUMN Alan;

--KRİTİK KOD: Aynı kitaba 2 farklı yazar ekledim fakat ikiside yazar sırası 1 olarak girdim fakat hata vermedi, bende bu kodu yazarak bu karmaşanın önüne geeçtim.
ALTER TABLE KitapYazarlari
ADD CONSTRAINT UQ_Kitap_YazarSirasi UNIQUE (KitapID, YazarSirasi);


--Kitaplar ve Yazarlar tablosundan KitapID ve YazarID yi yeni tablomuza aktarıyoruz.
INSERT INTO KitapYazarlari (KitapID, YazarID, YazarSirasi, KatkiTuru)
SELECT KitapID, YazarID, 1 AS YazarSirasi,  'Yazar' AS KatkiTuru
FROM Kitaplar
WHERE YazarID IS NOT NULL;


--Kitaplar tablosunda YazarID FK şeklinde idi, önce O FK çözülür.
ALTER TABLE Kitaplar
DROP CONSTRAINT FK_Kitaplar_Yazarlar;


--Kitaplar tablosundan YazarID sütununu kaldırıyoruz.
ALTER TABLE Kitaplar
DROP COLUMN YazarID;

--Birden fazla yazarı olan en az iki kitap ekle.
INSERT INTO Kitaplar(KitapAdi,KategoriID,Fiyat,Stok,YayinTarihi)   --kitapID 16
VALUES('İlyada',1,250.0,100,'1869-10-10');

INSERT INTO Kitaplar(KitapAdi,KategoriID,Fiyat,Stok,YayinTarihi)    --kitapID 17
VALUES('Don Kişot',1,350.0,100,'1369-11-12');

INSERT INTO Kitaplar(KitapAdi,KategoriID,Fiyat,Stok,YayinTarihi)    --kitapID 18
VALUES('Beyaz Diş',1,145.0,75,'1916-06-09');

INSERT INTO Kitaplar(KitapAdi,KategoriID,Fiyat,Stok,YayinTarihi)    --kitapID 19
VALUES('Orta Direk',2,250.0,25,'1916-06-12');


INSERT INTO Yazarlar(Ad,Soyad,Ulke,DogumTarihi)
VALUES('Homeros','Max','Amerika','1845-07-05'),('Cervantes','Frank','Brezilya','1350-12-12');

INSERT INTO Yazarlar(Ad,Soyad,Ulke,DogumTarihi)
VALUES('Jack','London','İspanya','1850-12-12'),('Yaşar','Kemal','Türkiye','1880-03-25');   --yazarID 18   yazarID 19

INSERT INTO KitapYazarlari(KitapID,YazarID,YazarSirasi,KatkiTuru)
VALUES(16,16,1,'Yazar'),(16,17,1,'Yazar');

UPDATE KitapYazarlari SET YazarSirasi=2 WHERE YazarID=17;

INSERT INTO KitapYazarlari(KitapID,YazarID,YazarSirasi,KatkiTuru)
VALUES(18,18,1,'Yazar'),(18,19,2,'Yazar');

INSERT INTO KitapYazarlari(KitapID,YazarID,YazarSirasi,KatkiTuru)
VALUES(19,18,2,'Yazar'),(19,19,1,'Yazar'); 


INSERT INTO KitapYazarlari(KitapID,YazarID,YazarSirasi,KatkiTuru)
VALUES(17,10,1,'Yazar'),(17,17,2,'Yazar');

INSERT INTO KitapYazarlari(KitapID,YazarID,YazarSirasi,KatkiTuru)
VALUES(9,3,2,'Editör');

INSERT INTO KitapYazarlari(KitapID,YazarID,YazarSirasi,KatkiTuru)
VALUES(5,9,2,'Editör');

INSERT INTO KitapYazarlari(KitapID,YazarID,YazarSirasi,KatkiTuru)
VALUES(1,10,2,'Editör');


--Kitapları yazarlarıyla birlikte listele.
SELECT ky.KitapID as 'Kitap ID', k.KitapAdi as 'Kitap Adı', y.Ad as 'Yazar Adı', y.Soyad as 'Yazar Soyadı'
FROM Kitaplar k 
INNER JOIN KitapYazarlari ky ON k.KitapID=ky.KitapID
INNER JOIN Yazarlar y ON y.YazarID=ky.YazarID;


--Her kitabın tüm yazarlarını tek satırda göster.
SELECT k.KitapID AS 'Kitap ID', k.KitapAdi AS 'Kitap Adı',
    STRING_AGG(CONCAT(y.Ad, ' ', y.Soyad), ', ') WITHIN GROUP (ORDER BY ky.YazarSirasi ASC) AS 'Yazarlar'
FROM Kitaplar k
INNER JOIN KitapYazarlari ky ON k.KitapID = ky.KitapID
INNER JOIN Yazarlar y ON y.YazarID = ky.YazarID
GROUP BY k.KitapID, k.KitapAdi;

--(CONCAT(y.Ad, ' ', y.Soyad), ', ')  İKİ STRİNG İFADEYİ YAN YANA YAZAR.

--STRING_AGG(..., ', '): Aynı kitaba ait tüm yazarları aralarına virgül ve boşluk koyarak tek bir hücrede yan yana toplar.

--WITHIN GROUP (ORDER BY ky.YazarSirasi ASC): Yazarların mantıksal sıralamasını korur (Örn: 1. Yazar en başa gelir).


--En fazla ortak kitap yazan yazar ikilisini bul.
SELECT TOP 1
    y1.Ad + ' ' + y1.Soyad AS '1. Yazar',
    y2.Ad + ' ' + y2.Soyad AS '2. Yazar',
    COUNT(ky1.KitapID) AS 'Ortak Kitap Sayısı'
FROM KitapYazarlari ky1
INNER JOIN KitapYazarlari ky2 ON ky1.KitapID = ky2.KitapID AND ky1.YazarID < ky2.YazarID
INNER JOIN Yazarlar y1 ON ky1.YazarID = y1.YazarID
INNER JOIN Yazarlar y2 ON ky2.YazarID = y2.YazarID
GROUP BY y1.Ad, y1.Soyad, y2.Ad, y2.Soyad, ky1.YazarID, ky2.YazarID
ORDER BY COUNT(ky1.KitapID) DESC;


--Hem yazar hem editör olarak görev alan kişileri listele.
SELECT y.YazarID, y.Ad + ' ' + y.Soyad AS 'Yazar İsmi'
FROM Yazarlar y
INNER JOIN KitapYazarlari ky ON y.YazarID = ky.YazarID
WHERE ky.KatkiTuru IN ('Yazar', 'Editör')
GROUP BY y.YazarID, y.Ad, y.Soyad
HAVING COUNT(DISTINCT ky.KatkiTuru) = 2;