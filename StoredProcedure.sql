SELECT * FROM Kategoriler;
SELECT * FROM Kitaplar;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;

 --View dan farkı Procedure içerisinide dinamik olarak işlemler yapılabilir, Dışarrıdan gelen parametreye göre tablolarda 
 --değişiklikler eş zamanalı olarak gerçekleştirilir.
 --View da sadece karmaşık kod tekrarını önler, SELECT atarsın, sadece görüntüleme, tabolarda manipülasyon yapılmaz.

CREATE PROCEDURE YazarlariGetir
AS
BEGIN
SELECT * FROM Yazarlar;
END

EXEC YazarlariGetir;


CREATE PROCEDURE MusteriSehirleriGetir
AS
BEGIN 
SELECT m.Sehir as [Şehirler] FROM Musteriler m ;
END

EXEC MusteriSehirleriGetir;

--Stored Procedure en önemli özelliği parametre almasıdır.

CREATE PROCEDURE Islem1
	@yazarID INT
AS
BEGIN
SELECT * FROM Yazarlar WHERE YazarID= @yazarID;
END

EXEC Islem1 @yazarID=4;

-----------------------------------------------------------------

CREATE PROCEDURE Islem2
	@kategoriAdi VARCHAR(200),
	@aciklama VARCHAR(200)
AS
BEGIN
SELECT k.KategoriAdi as 'Kategori Adı', k.Aciklama as 'Açıklama'
FROM Kategoriler k
WHERE (KategoriAdi=@kategoriAdi AND Aciklama=@aciklama)
END

EXEC Islem2 @kategoriAdi='Roman',
			@aciklama='Hayal ötesi anlatım';

---------------------------------------------------------------------

ALTER PROCEDURE Islem3
	@kategoriAdi VARCHAR(200),
	@aciklama VARCHAR(200)
AS
BEGIN
SELECT k.KategoriAdi as 'Kategori Adı', k.Aciklama as 'Açıklama'
FROM Kategoriler k
WHERE (KategoriAdi=@kategoriAdi AND Aciklama=@aciklama)
END

EXEC Islem3 @kategoriAdi='Roman',
			@aciklama='Hayal ötesi anlatım';

---------------------------------------------------------------------

--Sadece SELECT işlemi yapılmaz. Şimdi INSERT yapacağız.

CREATE PROCEDURE Islem4
    @musteriAdi VARCHAR(200),
    @musteriSoyadi VARCHAR(200),
    @musteriEmail VARCHAR(200),
    @musteriSehri VARCHAR(200),
    @musteriKayitTarihi DATE = NULL -- Varsayılan olarak NULL verdik
AS
BEGIN

    -- Eğer tarih parametresi dışarıdan gönderilmediyse (NULL ise) bugünün tarihini al
    IF @musteriKayitTarihi IS NULL
        SET @musteriKayitTarihi = GETDATE();

    INSERT INTO Musteriler (Ad, Soyad, Email, Sehir, KayitTarihi)
    VALUES (@musteriAdi, @musteriSoyadi, @musteriEmail, @musteriSehri, @musteriKayitTarihi);
END;

EXEC Islem4 
    @musteriAdi = 'Derda',
    @musteriSoyadi = 'Ugurtay',
    @musteriEmail = 'derda@gmail.com',
    @musteriSehri = 'Bursa';

-------------------------------------------------------------------------------------------
