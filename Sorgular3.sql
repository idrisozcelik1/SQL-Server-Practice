SELECT * FROM Kategoriler;
SELECT * FROM Kitaplar;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;



--Toplam kitap sayısını bul.
--Count(*) ID'leri sayarak satır sayısını bulur.
SELECT Count(*) as 'Kitap Sayisi' 
FROM Kitaplar;

--Kitapların ortalama fiyatını hesapla.
SELECT AVG(Fiyat) as 'Ortalama Fiyat'
FROM Kitaplar;

--En pahalı ve en ucuz kitabın fiyatını bul.
SELECT Min(Fiyat) as 'Minimum Fiyat' , Max(Fiyat) as 'Maximum Fiyat'
FROM Kitaplar;

--Toplam stok miktarını hesapla.
SELECT Sum(Stok) as 'Toplam Stok'
FROM Kitaplar;

--Her şehirde kaç müşteri olduğunu göster.
SELECT Sehir, COUNT(*) AS MusteriSayisi
FROM Musteriler
GROUP BY Sehir
ORDER BY MusteriSayisi ASC;

--Her kategoride kaç kitap olduğunu göster.
SELECT KategoriID, COUNT(*) AS KitapSayisi
FROM Kitaplar
GROUP BY KategoriID;

--Her yazarın kaç kitabı olduğunu göster.
SELECT YazarID, COUNT(*) AS KitapSayisi
FROM Kitaplar
GROUP BY YazarID;

--Her siparişte toplam kaç adet kitap alındığını hesapla.
SELECT SiparisID, SUM(Adet) AS ToplamKitapMiktari
FROM SiparisDetaylari
GROUP BY SiparisID
ORDER BY SiparisID ASC;

--Toplam sipariş tutarı 500 TL’den yüksek müşterileri bul.
SELECT 
    m.MusteriID,
    m.Ad,
    m.Soyad,
    SUM(sd.Adet * sd.BirimFiyat) AS ToplamHarcama
FROM Musteriler m
INNER JOIN Siparisler s ON m.MusteriID = s.MusteriID
INNER JOIN SiparisDetaylari sd ON s.SiparisID = sd.SiparisID
GROUP BY m.MusteriID, m.Ad, m.Soyad
HAVING SUM(sd.Adet * sd.BirimFiyat) > 500
ORDER BY ToplamHarcama DESC;


--Ortalama kitap fiyatı 200 TL’den yüksek kategorileri listele.
SELECT 
    k.KategoriAdi,
    AVG(kt.Fiyat) AS OrtalamaFiyat
FROM Kitaplar kt
INNER JOIN Kategoriler k ON kt.KategoriID = k.KategoriID
GROUP BY k.KategoriAdi
HAVING AVG(kt.Fiyat) > 200
ORDER BY OrtalamaFiyat DESC;
