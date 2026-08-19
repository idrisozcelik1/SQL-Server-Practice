SELECT * FROM Kitaplar;
SELECT * FROM Kategoriler;
SELECT * FROM Musteriler;
SELECT * FROM Siparisler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Yazarlar;

--En çok satılan üç kitabı bul.
SELECT TOP 3  k.KitapID as 'Kitap ID', k.KitapAdi as 'Kitap Adı', SUM(sd.Adet) AS ToplamSatisAdedi
FROM SiparisDetaylari sd
INNER JOIN Kitaplar k ON sd.KitapID = k.KitapID
GROUP BY k.KitapID, k.KitapAdi;



--En fazla para harcayan müşteriyi bul.
SELECT TOP 1 m.Ad as 'Müşteri Adı', m.Soyad as 'Müşteri Soyadı', SUM(s.ToplamTutar) as 'Toplam Harcama'
FROM Musteriler m
LEFT JOIN Siparisler s ON m.MusteriID=s.MusteriID
GROUP BY m.Ad,m.Soyad
ORDER BY [Toplam Harcama] DESC;



--Her müşterinin toplam sipariş sayısını ve harcadığı toplam tutarı göster.
SELECT m.MusteriID as 'Müşteri ID', m.Ad as 'Müşteri Adı', m.Soyad as 'Müşteri Soyadı',
    COUNT(s.SiparisID) as 'ToplamSiparisSayisi',
    SUM(s.ToplamTutar) as 'ToplamHarcama'
FROM Musteriler m
LEFT JOIN Siparisler s ON m.MusteriID = s.MusteriID
GROUP BY m.MusteriID, m.Ad, m.Soyad
HAVING SUM(s.ToplamTutar) IS NOT NULL
ORDER BY ToplamHarcama DESC;



--Her kategorinin toplam satış gelirini hesapla.
SELECT k.KategoriID as 'Kategori ID', k.KategoriAdi as 'Kategori Adı',
    SUM(sd.Adet * sd.BirimFiyat) as 'ToplamSatisGeliri'
FROM Kategoriler k
LEFT JOIN Kitaplar kit ON k.KategoriID = kit.KategoriID
LEFT JOIN SiparisDetaylari sd ON kit.KitapID = sd.KitapID
GROUP BY k.KategoriID, k.KategoriAdi
ORDER BY ToplamSatisGeliri DESC;



--Aylara göre sipariş sayısını göster.
SELECT 
    YEAR(SiparisTarihi) AS Yil,
    MONTH(SiparisTarihi) AS AyNo,
    COUNT(SiparisID) AS ToplamSiparisSayisi
FROM Siparisler
GROUP BY YEAR(SiparisTarihi), MONTH(SiparisTarihi)
ORDER BY Yil DESC, AyNo ASC;



--Hiç satılmamış kitapları listele.
SELECT k.KitapAdi as 'Kitap Adı'
FROM Kitaplar k
LEFT JOIN SiparisDetaylari sd ON k.KitapID=sd.KitapID
WHERE sd.KitapID IS NULL;



--Stoğu 5’in altında olan kitapları listele.
SELECT KitapAdi as 'Kitap Adı', Stok as 'Stok'
FROM Kitaplar 
WHERE Stok<5;


--Birden fazla sipariş vermiş müşterileri getir.
SELECT m.MusteriID as 'MÜŞTERİ ID', m.Ad as 'MÜŞTERİ ADI', m.Soyad as 'MÜŞTERİ SOYADI', COUNT(s.SiparisID) as 'Toplam Sipariş'
FROM Musteriler m
LEFT JOIN Siparisler s ON m.MusteriID=s.MusteriID
GROUP BY m.MusteriID,m.Ad,m.Soyad
HAVING COUNT(s.SiparisID)>1;



SELECT * FROM Kitaplar;
SELECT * FROM Kategoriler;
SELECT * FROM Musteriler;
SELECT * FROM Siparisler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Yazarlar;



--Her kategorideki en pahalı kitabı bul.
SELECT k.KategoriAdi as 'Kategori Adı', kit.KitapAdi as 'Kitap Adı', kit.Fiyat as 'Kitap Fiyatı'
FROM Kategoriler k
INNER JOIN Kitaplar kit ON k.KategoriID=kit.KategoriID
WHERE kit.Fiyat=(SELECT MAX(Fiyat) FROM Kitaplar WHERE KategoriID=kit.KategoriID);




--Satış adedi ortalamanın üzerinde olan kitapları bul.
SELECT k.KitapID as 'Kitap ID',k.KitapAdi as 'Kitap Adı', SUM(sd.Adet) as 'Toplam Satış Adedi'
FROM Kitaplar k
INNER JOIN SiparisDetaylari sd ON k.KitapID=sd.KitapID
GROUP BY k.KitapID,k.KitapAdi
HAVING SUM(sd.Adet) > (SELECT AVG(ToplamSatis)
    FROM
    (
        SELECT KitapID, SUM(Adet) AS ToplamSatis
        FROM SiparisDetaylari
        GROUP BY KitapID
    ) AS KitapSatislari);



   

