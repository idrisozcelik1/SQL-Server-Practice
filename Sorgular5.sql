/* Öğrenilen SQL sisteminin desteklemesine göre:
Stok miktarı sıfırın altına düşmesin diye bir trigger oluştur.
Yeni sipariş detayı eklenince stok miktarını otomatik azaltan trigger yaz. 
Müşteri numarası alan bir stored procedure yaz ve müşterinin siparişlerini döndür. (+)
Kitap numarası alan bir procedure yaz ve kitabın toplam satış miktarını göster. (+)
Kitap adı ve yazar adında arama yapan bir sorgu hazırla. (+)
Kitaplar tablosunun fiyat alanına index ekle. (+)
Index kullanımının sorgu performansına etkisini araştır. */

SELECT * FROM Kategoriler;
SELECT * FROM Kitaplar;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;

--Müşteri numarası alan bir stored procedure yaz ve müşterinin siparişlerini döndür.

CREATE PROCEDURE MusteriSiparisDon
	@musteriID INT
AS
BEGIN
SELECT SiparisID as 'Siparis Numarası', MusteriID as 'Müşteri Numarası', 
	   SiparisTarihi as 'Sipariş Tarihi', Durum as 'Sipariş Durumu', ToplamTutar as 'Sipariş Toplam Tutarı'
FROM Siparisler
WHERE MusteriID=@musteriID;
END

EXEC MusteriSiparisDon
	@musteriID=1;


--Kitap numarası alan bir procedure yaz ve kitabın toplam satış miktarını göster.

CREATE PROCEDURE KitapToplamSatisGetir
	@kitapID INT
AS
BEGIN
SELECT sd.KitapID 'Kitap Numarası', SUM(sd.Adet) as 'Toplam Satış Miktarı'
FROM SiparisDetaylari sd
WHERE sd.KitapID=@kitapID
GROUP BY sd.KitapID;
END

EXEC KitapToplamSatisGetir
	@kitapID=1;


--Kitaplar tablosunun fiyat alanına index ekle.
CREATE INDEX index_fiyat
ON Kitaplar(Fiyat);

--Kitap adı ve yazar adında arama yapan bir sorgu hazırla.
CREATE PROCEDURE aramaYap
	@kitapAdi VARCHAR(200),
	@yazarAdi VARCHAR(200)
AS
BEGIN
SELECT k.KitapAdi as 'Kitap Adı', y.Ad as 'Yazar Adı', y.Soyad as 'Yazar Soyadı'
FROM Yazarlar y 
LEFT JOIN Kitaplar k ON y.YazarID=k.YazarID
WHERE k.KitapAdi LIKE '%' + @kitapAdi + '%' 
       OR y.Ad LIKE '%' + @yazarAdi + '%';
END 
GO

EXEC aramaYap
	@kitapAdi='Nutuk',
	@yazarAdi='Oğuz';



--MÜŞTERİ ADI VE SİPARİŞ DURUMUNA GÖRE ARAMA YAPAN PROCEDURE YAZ.
CREATE PROCEDURE aramaYap2
	@musteriAdi VARCHAR(200),
	@siparisDurumu INT
AS 
BEGIN
SELECT m.Ad as 'Müşteri Adı', s.Durum as 'Sipariş Durumu'
FROM Musteriler m
INNER JOIN Siparisler s ON m.MusteriID=s.MusteriID
WHERE m.Ad LIKE '%'+@musteriAdi+'%' OR s.Durum LIKE @siparisDurumu;
END 
GO

EXEC aramaYap2	
	@musteriAdi='Elif',
	@siparisDurumu=2;


DROP PROCEDURE aramaYap2;





