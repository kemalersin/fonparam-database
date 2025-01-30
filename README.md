# 💾️ FonParam Veritabanı

Bu dizin, FonParam projesinin veritabanı şemasını ve ilgili SQL betiklerini içerir.

## 📊 Veritabanı Yapısı

### 🏢 Fon Yönetim Şirketleri (`fund_management_companies`)
- `code` (VARCHAR(10)) - Şirket kodu (PK)
- `title` (VARCHAR(255)) - Şirket adı
- `logo` (VARCHAR(255)) - Logo dosya yolu
- `total_funds` (INT) - Toplam fon sayısı
- `avg_yield_1d` (DECIMAL(10,4)) - Ortalama günlük getiri
- `avg_yield_1w` (DECIMAL(10,4)) - Ortalama haftalık getiri
- `avg_yield_1m` (DECIMAL(10,4)) - Ortalama aylık getiri
- `avg_yield_6m` (DECIMAL(10,4)) - Ortalama 6 aylık getiri
- `avg_yield_ytd` (DECIMAL(10,4)) - Ortalama yıl başından itibaren getiri
- `avg_yield_1y` (DECIMAL(10,4)) - Ortalama yıllık getiri
- `avg_yield_3y` (DECIMAL(10,4)) - Ortalama 3 yıllık getiri
- `avg_yield_5y` (DECIMAL(10,4)) - Ortalama 5 yıllık getiri

### 📋 Fon Tipleri (`fund_types`)
- `type` (VARCHAR(20)) - Fon tipi kodu (PK)
- `short_name` (VARCHAR(50)) - Kısa ad
- `long_name` (VARCHAR(100)) - Uzun ad
- `group_name` (VARCHAR(50)) - Grup adı

### 📈 Fonlar (`funds`)
- `code` (VARCHAR(10)) - Fon kodu (PK)
- `management_company_id` (VARCHAR(10)) - Yönetici şirket kodu (FK)
- `title` (VARCHAR(255)) - Fon adı
- `type` (ENUM) - Fon tipi
- `tefas` (BOOLEAN) - TEFAS'ta işlem görme durumu
- `risk_value` (TINYINT) - Risk değeri (1-7)
- `purchase_value_day` (TINYINT) - Alış valörü (gün)
- `sale_value_day` (TINYINT) - Satış valörü (gün)
- `has_historical_data` (BOOLEAN) - Tarihsel veri varlığı
- `historical_data_check_date` (DATE) - Son tarihsel veri kontrol tarihi

### 📊 Fon Getirileri (`fund_yields`)
- `code` (VARCHAR(10)) - Fon kodu (PK, FK)
- `yield_1d` (DECIMAL(10,4)) - Günlük getiri
- `yield_1w` (DECIMAL(10,4)) - Haftalık getiri
- `yield_1m` (DECIMAL(10,4)) - Aylık getiri
- `yield_3m` (DECIMAL(10,4)) - 3 aylık getiri
- `yield_6m` (DECIMAL(10,4)) - 6 aylık getiri
- `yield_ytd` (DECIMAL(10,4)) - Yıl başından itibaren getiri
- `yield_1y` (DECIMAL(10,4)) - Yıllık getiri
- `yield_3y` (DECIMAL(10,4)) - 3 yıllık getiri
- `yield_5y` (DECIMAL(10,4)) - 5 yıllık getiri

### 📅 Fon Geçmiş Değerleri (`fund_historical_values`)
- `code` (VARCHAR(10)) - Fon kodu (FK)
- `date` (DATE) - Tarih
- `value` (DECIMAL(10,6)) - Birim pay değeri
- `aum` (DECIMAL(20,2)) - Toplam portföy değeri (TL)
- `yield` (DECIMAL(10,4)) - Günlük getiri (%)
- `cumulative_cashflow` (DECIMAL(20,2)) - Kümülatif nakit akışı
- `investor_count` (INT) - Yatırımcı sayısı
- `management_fee` (DECIMAL(5,2)) - Yıllık yönetim ücreti (%)
- `risk_value` (TINYINT) - Risk değeri (1-7)
- `purchase_value_day` (TINYINT) - Alış valörü (gün)
- `sale_value_day` (TINYINT) - Satış valörü (gün)
- `shares_total` (DECIMAL(20,2)) - Toplam pay adedi
- `shares_active` (DECIMAL(20,2)) - Aktif pay adedi
- `occupancy_rate` (DECIMAL(5,2)) - Doluluk oranı (%)
- `market_share` (DECIMAL(5,2)) - Pazar payı (%)

## 🔍 İlişkiler

1. `funds.management_company_id` → `fund_management_companies.code`
2. `funds.type` → `fund_types.type`
3. `fund_yields.code` → `funds.code`
4. `fund_historical_values.code` → `funds.code`

## 📝 Notlar

- Tüm tablolar UTF-8 Türkçe karakter desteğine sahiptir
- Tarihsel verisi olmayan fonlar `has_historical_data = FALSE` olarak işaretlenir
- Tarihsel verisi olmayan fonların kontrolü her 15 günde bir tekrarlanır
- `fund_historical_values` tablosu son 1 ay hariç son 1 yılın verilerini içermektedir

## 📜 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakınız.

