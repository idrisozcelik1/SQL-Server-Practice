18. Ödeme sistemi

Aşağıdaki tabloları oluştur:

OdemeYontemleri

En az şu alanlar bulunmalıdır:

OdemeYontemiID
OdemeYontemiAdi
AktifMi
OlusturmaTarihi

Ödeme yöntemi örnekleri:

Kredi Kartı
Banka Kartı
Havale
Kapıda Ödeme

Odemeler

En az şu alanlar bulunmalıdır:

OdemeID
SiparisID
OdemeYontemiID
OdemeTarihi
Tutar
OdemeDurumu
IslemNumarasi
Aciklama

Kurallar
Ödeme tutarı sıfırdan büyük olmalıdır.
İşlem numarası benzersiz olmalıdır.
Ödeme durumu yalnızca Bekliyor, Başarılı, Başarısız veya İade Edildi olabilir.
Var olmayan bir sipariş için ödeme oluşturulamamalıdır.
Bir sipariş için birden fazla ödeme denemesi yapılabilir.
Aynı siparişe ait başarılı ödemelerin toplamı siparişin ödenecek tutarını geçmemelidir.
Siparişin tamamı ödenmeden sipariş durumu Hazırlanıyor yapılamamalıdır.
Başarısız ödeme siparişin ödenmiş tutarına dahil edilmemelidir.

Görevler
Ödeme tablolarını oluştur.
En az üç ödeme yöntemi ekle.
Başarılı ve başarısız ödeme örnekleri ekle.
Her siparişin toplam tutarını, ödenen tutarını ve kalan tutarını göster.
Ödemesi tamamlanmamış siparişleri listele.
Birden fazla başarısız ödeme denemesi bulunan siparişleri getir.
En fazla kullanılan ödeme yöntemini bul.
Ödeme yöntemlerine göre toplam tahsilat tutarını göster.
Başarılı ödeme gerçekleştiğinde sipariş durumunu otomatik olarak Hazırlanıyor yapan bir işlem oluştur.
Sipariş tutarından fazla ödeme yapılmasını engelle.
