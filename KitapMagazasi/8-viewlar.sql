--Bir veya daha fazla tablodaki verileri gösteren sanal bir tablodur. İçinde fiziksel veri saklamaz, sadece arkasında çalışan 
--SELECT sorgunu saklar.
--Veritabanında yer kaplamaz.
--Uzun ve karmaşık join tablolarını tek satıra indirger.
--Kolaylık: Uzun SQL kodlarını her seferinde yazmak yerine bir view içine kaydedip kısa yoldan çağırabilirsiniz.
--Güvenlik: Kullanıcılara tüm tablolara erişim vermek yerine, sadece görmelerini istediğiniz kolonları bir view ile sunabilirsiniz.
--Hız ve Düzen: Karmaşık raporlama işlemlerini basit ve anlaşılır hale getirir.

SELECT * FROM Kategoriler;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;
SELECT * FROM Kitaplar;



--KitapDetaylari
--Şu alanları göstermeli: KitapID, Kitap adı, Yazarın adı ve soyadı, Kategori adı, Fiyat, Stok

CREATE VIEW KitapDetaylari AS
SELECT k.KitapID as 'Kitap ID', k.KitapAdi as 'Kitap Adı', k.Fiyat as 'Fiyat', k.Stok as 'Stok', 
       y.Ad as 'Yazar Adı', y.Soyad as 'Yazar Soyadı', ktg.KategoriAdi as 'Kategori Adı'
FROM Kitaplar k 
INNER JOIN Yazarlar y ON k.YazarID=y.YazarID
INNER JOIN Kategoriler ktg ON k.KategoriID=ktg.KategoriID;
GO

SELECT * FROM KitapDetaylari;

UPDATE Siparisler SET Durum='Hazırlanıyor' WHERE ToplamTutar=390.0;


--SiparisOzeti
--Şu alanları göstermeli: SiparişID, Müşteri adı ve soyadı, Sipariş tarihi, Sipariş durumu, 
--Siparişteki toplam ürün adedi, Hesaplanan toplam tutar

CREATE VIEW SiparisOzeti AS
SELECT s.SiparisID as 'Sipariş ID', m.Ad as 'Müşteri Adı', m.Soyad as 'Müşteri Soyadı', s.SiparisTarihi as 'Sipariş Tarihi',
       s.Durum as 'Sipariş Durumu', SUM(sd.Adet) AS ToplamUrunAdedi,
       SUM(sd.Adet * sd.BirimFiyat) AS ToplamTutar
FROM Siparisler s
INNER JOIN Musteriler m ON s.MusteriID=m.MusteriID
INNER JOIN SiparisDetaylari sd ON s.SiparisID=sd.SiparisID  
GROUP BY s.SiparisID, m.Ad, m.Soyad, s.SiparisTarihi, s.Durum;
GO

SELECT * FROM SiparisOzeti;


--StoktaOlmayanKitaplar
--Yalnızca stok miktarı 0 olan kitapları göstermeli.

CREATE VIEW StoktaOlmayanlar AS
SELECT KitapID as 'Kitap ID', KitapAdi as 'Kitap Adı', Stok  
FROM Kitaplar 
WHERE Stok=0;
GO



--KitapDetaylari üzerinden fiyatı 250 TL’den yüksek kitapları getir.
SELECT * FROM KitapDetaylari
WHERE Fiyat>250;

--SiparisOzeti üzerinden en yüksek tutarlı üç siparişi getir.
SELECT TOP 3 * 
FROM SiparisOzeti 
ORDER BY ToplamTutar DESC;
