SELECT * FROM Kategoriler;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;
SELECT * FROM Kitaplar;



--Her yazarın toplam kaç adet stoğu (kitap adedi) olduğunu yazar ID'sine göre gruplayarak göster.
SELECT YazarID,SUM(Stok)
FROM Kitaplar
GROUP BY YazarID;

--Her kategorinin en pahalı ve en ucuz kitabının fiyatını listeleyin.
SELECT KategoriID, MAX(Fiyat) as 'En Pahalı', MIN(Fiyat) as 'En Ucuz'
FROM Kitaplar
GROUP BY KategoriID;

--En az 2 sipariş vermiş olan müşterilerin MusteriID bilgilerini ve toplam sipariş sayılarını getirin.
SELECT MusteriID, COUNT(SiparisID) AS ToplamSiparisSayisi
FROM Siparisler
GROUP BY MusteriID
HAVING COUNT(SiparisID) >= 2;

--Toplam stok miktarı 50'den fazla olan kategorilerin KategoriID değerlerini ve toplam stok sayılarını bulun.
SELECT KategoriID, SUM(Stok)
FROM Kitaplar
GROUP BY KategoriID
HAVING SUM(Stok)>=50;

--Kitapların adını ve ait oldukları kategorinin adını listele.
SELECT k.KitapAdi as 'Kitap Adı', ktg.KategoriAdi as 'Kategori Adı'
FROM Kitaplar k
LEFT JOIN Kategoriler ktg ON k.KategoriID=ktg.KategoriID;

--Sipariş yapan müşterilerin adını, soyadını ve sipariş tarihlerini göster.
SELECT m.MusteriID, m.Ad as 'Müşteri Adı', m.Soyad as 'Müşteri Soyadı', s.SiparisTarihi
FROM Musteriler m
LEFT JOIN Siparisler s ON m.MusteriID=s.MusteriID;

--Sipariş edilen kitapların adını ve sipariş detayındaki BirimFiyat bilgisini listele.
SELECT k.KitapAdi as 'Kitap Adı', sd.BirimFiyat as 'Birim Fiyat'
FROM Kitaplar k 
INNER JOIN SiparisDetaylari sd ON K.KitapID=SD.KitapID;

--Bünyesinde henüz hiç kitap bulunmayan kategorileri LEFT JOIN kullanarak listele.
SELECT ktg.KategoriAdi as 'Kategori Adı', k.KitapAdi as 'Kitap Adı'
FROM Kategoriler ktg
LEFT JOIN Kitaplar k ON ktg.KategoriID=k.KategoriID
WHERE KitapAdi IS NULL;


INSERT INTO Kategoriler(KategoriAdi,Aciklama) VALUES('Masal','Hayal ötesi anlatım');

--Açıldığı günden beri hiç sipariş edilmemiş (hiç satılmamış) kitapları LEFT JOIN ile bul.
SELECT K.KitapID as 'Kitap ID', k.KitapAdi as 'Kitap Adı'
FROM Kitaplar k 
LEFT JOIN SiparisDetaylari sd ON k.KitapID=sd.KitapID
WHERE sd.SiparisID IS NULL;

--Stok miktarı, tüm kitapların ortalama stok miktarından fazla olan kitapları getir.
SELECT k.KitapID as [Kitap ID], k.KitapAdi as [Kitap Adı], k.Stok as [Stok Miktarı]
FROM Kitaplar k
WHERE k.Stok > (SELECT AVG(k1.Stok) FROM Kitaplar k1);

--Veritabanında en yüksek stok sayısına sahip kitap veya kitapları subquery kullanarak getir.
SELECT k.KitapAdi as [Kitap Adı], k.Stok as [Stok Miktarı]
FROM Kitaplar k
WHERE k.Stok >= (SELECT MAX(Stok) FROM Kitaplar);

--En pahalı kitabın yazarına ait YazarID bilgisini alt sorgu ile getir.
SELECT YazarID
FROM Kitaplar
WHERE Fiyat = (SELECT MAX(Fiyat) FROM Kitaplar);

--Kendi kategorisinin ortalama fiyatından daha ucuz olan kitapları bulun.
SELECT k1.KitapID as [Kitap ID], k1.KitapAdi as [Kitap Adı], k1.KategoriID as [Kategori ID], k1.Fiyat as [Fiyat]
FROM Kitaplar k1
WHERE k1.Fiyat < (
    SELECT AVG(k2.Fiyat)
    FROM Kitaplar k2
    WHERE k2.KategoriID = k1.KategoriID
);


--YazarKitapStok VIEW'ı: Sadece YazarID, YazarAd ve yazarın ToplamStok miktarını gösteren bir VIEW oluştur.
CREATE VIEW YazarKitapStok AS
SELECT y.YazarID as [Yazar ID], y.Ad as [Yazar Adı], y.Soyad as [Yazar Soyadı], SUM(k.Stok) as [Toplam Stok]
FROM Yazarlar y
LEFT JOIN Kitaplar k ON y.YazarID=k.YazarID
GROUP BY y.YazarID, y.Ad, y.Soyad
GO

SELECT * FROM YazarKitapStok;


--VIEW Üzerinden Filtreleme: Oluşturduğun YazarKitapStok VIEW'ı üzerinden toplam stoğu 100'den az olan yazarları sorgula.

SELECT * FROM YazarKitapStok WHERE [Toplam Stok]<100;


SELECT * FROM Kategoriler;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;
SELECT * FROM Kitaplar;

--Müşterilerin adı, soyadı ve 2026 yılı Temmuz ayında (SiparisTarihi) verdikleri siparişlerin tarihlerini listele.
SELECT m.Ad as [Müşteri Adı],m.Soyad as [Müşteri Soyadı], s.SiparisTarihi as [Sipariş Tarihi]
FROM Siparisler s
INNER JOIN Musteriler m ON s.MusteriID = m.MusteriID
WHERE YEAR(s.SiparisTarihi) = 2026  AND  MONTH(s.SiparisTarihi) = 7;

--Her kategorinin adını ve o kategoriye ait toplam kitap stok miktarını göster.
SELECT ktg.KategoriID as [Kategori ID], ktg.KategoriAdi as [Kategori Adı], SUM(k.Stok) as [Toplam Stok]
FROM Kategoriler ktg 
LEFT JOIN Kitaplar k ON ktg.KategoriID=k.KategoriID
GROUP BY ktg.KategoriID, ktg.KategoriAdi;

--Sipariş detaylarında birim fiyatı 150 TL'den büyük olan satışların kitap adını ve satılan adet bilgisini listele.
SELECT sd.Adet as [Satılan Miktar], k.KitapAdi as [Kitap Adı]
FROM SiparisDetaylari sd
INNER JOIN Kitaplar k ON sd.KitapID=k.KitapID
WHERE sd.BirimFiyat>150;

--Her müşterinin adını, soyadını ve şimdiye kadar sipariş detaylarında harcadığı toplam tutarı (Adet * BirimFiyat) hesapla.
SELECT 
m.MusteriID as [MüşteriID], m.Ad as [Müşteri Adı], m.Soyad as [Müşteri Soyadı], SUM(sd.Adet * sd.BirimFiyat) AS ToplamHarcama
FROM Musteriler m
INNER JOIN Siparisler s ON m.MusteriID = s.MusteriID
INNER JOIN SiparisDetaylari sd ON s.SiparisID = sd.SiparisID
GROUP BY m.MusteriID, m.Ad, m.Soyad;


INSERT INTO Musteriler(Ad,Soyad,Email,Sehir,KayitTarihi)
VALUES('Barış','Kayı','baris@gmail.com','Kırşehir','2026-08-04');

--Sistemde kayıtlı olan ancak henüz hiç sipariş vermemiş müşterilerin adını ve soyadını LEFT JOIN kullanarak bul.
SELECT m.Ad as [Müşteri Adı], m.Soyad as [Müşteri Soyadı]
FROM Musteriler m 
LEFT JOIN Siparisler s ON m.MusteriID=s.MusteriID
WHERE s.SiparisID IS NULL;

--Her yazarın adını, soyadını ve yazdığı kitapların ortalama fiyatını AVG() fonksiyonu ile listele.
SELECT y.YazarID AS [Yazar ID], y.Ad as [Yazar Adı], y.Soyad as [Yazar Soyadı], AVG(k.Fiyat) as [Ortalama Fiyat]
FROM Yazarlar y 
LEFT JOIN Kitaplar k ON y.YazarID=k.YazarID
GROUP BY y.YazarID,y.Ad,y.Soyad;



SELECT * FROM Kategoriler;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;
SELECT * FROM Kitaplar;



--Müşteri adı-soyadı ile birlikte sipariş durumunun 'Tamamlandı' olduğu siparişlerin tarihlerini listele.
SELECT m.Ad as [Müşteri Adı], m.Soyad as [Müşteri Soyadı], s.Durum as [Sipariş Durumu], s.SiparisTarihi as [Sipariş Tarihi]
FROM Musteriler m
LEFT JOIN Siparisler s ON m.MusteriID=s.MusteriID
WHERE s.Durum='Tamamlandı';


--Tüm yazarların adını, soyadını ve varsa kitap sayılarını listele. Kitabı olmayan yazarların kitap sayısı 0 veya NULL görünebilir.
SELECT y.YazarID as 'Yazar ID', y.Ad as 'Yazar Adı', y.Soyad as 'Yazar Soyadı', COUNT(k.KitapID) as 'Kitap Sayısı'
FROM Yazarlar y 
LEFT JOIN Kitaplar k ON y.YazarID=k.YazarID
GROUP BY y.YazarID,y.Ad,y.Soyad;


--Veritabanındaki en pahalı kitabın ait olduğu kategorinin adını alt sorgu (subquery) kullanarak bul.
SELECT KategoriAdi
FROM Kategoriler
WHERE KategoriID IN (
    SELECT KategoriID 
    FROM Kitaplar 
    WHERE Fiyat = (SELECT MAX(Fiyat) FROM Kitaplar)
);