19. Kargo ve teslimat sistemi

Aşağıdaki tabloları oluştur:

KargoFirmalari

Alanlar:

KargoFirmasiID
FirmaAdi
Telefon
WebAdresi
AktifMi
Kargolar

Alanlar:

KargoID
SiparisID
KargoFirmasiID
TakipNumarasi
KargoyaVerilmeTarihi
TahminiTeslimTarihi
TeslimTarihi
KargoDurumu
KargoUcreti
KargoHareketleri

Alanlar:

KargoHareketID
KargoID
HareketTarihi
Durum
Konum
Aciklama
Kurallar
Takip numarası benzersiz olmalıdır.
Kargo ücreti sıfırdan küçük olamaz.
Bir sipariş yalnızca başarılı ödeme sonrasında kargoya verilebilir.
Kargo durumu yalnızca aşağıdaki değerlerden biri olabilir:
Hazırlanıyor
Kargoya Verildi
Transfer Merkezinde
Dağıtımda
Teslim Edildi
Teslim Edilemedi
İade Edildi
Gerçek teslim tarihi, kargoya verilme tarihinden önce olamaz.
Tahmini teslim tarihi, kargoya verilme tarihinden önce olamaz.
Kargo Teslim Edildi durumuna getirildiğinde teslim tarihi boş bırakılamaz.
Görevler
Kargo tablolarını oluştur.
En az üç kargo firması ekle.
Siparişleri kargo firmalarıyla ilişkilendir.
Her kargonun hareket geçmişini listele.
Henüz teslim edilmemiş kargoları getir.
Tahmini teslim tarihi geçtiği halde teslim edilmemiş kargoları göster.
Ortalama teslimat süresini kargo firmasına göre hesapla.
En fazla sipariş taşıyan kargo firmasını bul.
Teslim edilemeyen kargoları müşteri bilgileriyle birlikte göster.
Kargo durumu Teslim Edildi olduğunda sipariş durumunu da Tamamlandı yapan bir trigger oluştur.
Bir siparişin kargo takip numarasını alan ve bütün kargo hareketlerini döndüren stored procedure yaz.
