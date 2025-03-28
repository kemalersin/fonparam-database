-- Veritabanını oluştur
CREATE DATABASE IF NOT EXISTS fonparam
CHARACTER SET utf8mb4
COLLATE utf8mb4_turkish_ci;

USE fonparam;

-- Fon yönetim şirketleri tablosu
CREATE TABLE fund_management_companies (
    code VARCHAR(10) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    logo VARCHAR(255),
    total_funds INT DEFAULT 0,
    avg_yield_1d DECIMAL(10,4),
    avg_yield_1w DECIMAL(10,4),
    avg_yield_1m DECIMAL(10,4),
    avg_yield_3m DECIMAL(10,4),
    avg_yield_6m DECIMAL(10,4),
    avg_yield_ytd DECIMAL(10,4),
    avg_yield_1y DECIMAL(10,4),
    avg_yield_3y DECIMAL(10,4),
    avg_yield_5y DECIMAL(10,4),
    INDEX idx_code_title (code, title),
    INDEX idx_title (title),
    FULLTEXT INDEX ft_title (title),
    FULLTEXT INDEX ft_code (code)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci;

-- Fon tipleri tablosu
CREATE TABLE fund_types (
    type ENUM('altin', 'borclanma_araclari', 'degisken', 'fon_sepeti', 'gumus', 
             'hisse_senedi', 'hisse_senedi_yogun', 'karma', 'katilim', 
             'kiymetli_madenler', 'para_piyasasi', 'serbest', 'yabanci', 'diger'),
    short_name VARCHAR(50) NOT NULL,
    long_name VARCHAR(100) NOT NULL,
    group_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (type, long_name),
    INDEX idx_type_group (type, group_name),
    INDEX idx_names (short_name, long_name),
    INDEX idx_group_name (group_name)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci;

-- Fonlar ana tablosu
CREATE TABLE funds (
    code VARCHAR(10) PRIMARY KEY,
    management_company_id VARCHAR(10),
    title VARCHAR(255) NOT NULL,
    type ENUM('altin', 'borclanma_araclari', 'degisken', 'fon_sepeti', 'gumus', 
             'hisse_senedi', 'hisse_senedi_yogun', 'karma', 'katilim', 
             'kiymetli_madenler', 'para_piyasasi', 'serbest', 'yabanci', 'diger'),
    tefas BOOLEAN,
    management_fee DECIMAL(5,2),
    risk_value TINYINT,
    purchase_value_day TINYINT,
    sale_value_day TINYINT, 
    has_historical_data BOOLEAN DEFAULT TRUE,
    historical_data_check_date DATE,
    FOREIGN KEY (management_company_id) REFERENCES fund_management_companies(code),
    FOREIGN KEY (type) REFERENCES fund_types(type),
    INDEX idx_type (type),
    INDEX idx_has_historical_data (has_historical_data),
    INDEX idx_title (title),
    INDEX idx_risk_value (risk_value),
    FULLTEXT INDEX ft_title (title),
    FULLTEXT INDEX ft_code (code)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci;

-- Fon getirileri tablosu
CREATE TABLE fund_yields (
    code VARCHAR(10) PRIMARY KEY,
    yield_1d DECIMAL(10,4),
    yield_1w DECIMAL(10,4),
    yield_1m DECIMAL(10,4),
    yield_3m DECIMAL(10,4),
    yield_6m DECIMAL(10,4),
    yield_ytd DECIMAL(10,4),
    yield_1y DECIMAL(10,4),
    yield_3y DECIMAL(10,4),
    yield_5y DECIMAL(10,4),
    FOREIGN KEY (code) REFERENCES funds(code),
    INDEX idx_yields_1d (yield_1d, code),
    INDEX idx_yields_1w (yield_1w, code),
    INDEX idx_yields_1m (yield_1m, code),
    INDEX idx_yields_3m (yield_3m, code),
    INDEX idx_yields_6m (yield_6m, code),
    INDEX idx_yields_ytd (yield_ytd, code),
    INDEX idx_yields_1y (yield_1y, code),
    INDEX idx_yields_3y (yield_3y, code),
    INDEX idx_yields_5y (yield_5y, code)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci;

-- Fon tipi bazında getiriler tablosu
CREATE TABLE fund_type_yields (
    type ENUM('altin', 'borclanma_araclari', 'degisken', 'fon_sepeti', 'gumus', 
             'hisse_senedi', 'hisse_senedi_yogun', 'karma', 'katilim', 
             'kiymetli_madenler', 'para_piyasasi', 'serbest', 'yabanci', 'diger'),
    yield_1d DECIMAL(10,4),
    yield_1w DECIMAL(10,4),
    yield_1m DECIMAL(10,4),
    yield_3m DECIMAL(10,4),
    yield_6m DECIMAL(10,4),
    yield_ytd DECIMAL(10,4),
    yield_1y DECIMAL(10,4),
    yield_3y DECIMAL(10,4),
    yield_5y DECIMAL(10,4),
    total_funds INT NOT NULL DEFAULT 0,
    total_aum DECIMAL(20,2),
    PRIMARY KEY (type),
    FOREIGN KEY (type) REFERENCES fund_types(type),
    INDEX idx_yields_1d (yield_1d),
    INDEX idx_yields_1w (yield_1w),
    INDEX idx_yields_1m (yield_1m),
    INDEX idx_yields_3m (yield_3m),
    INDEX idx_yields_6m (yield_6m),
    INDEX idx_yields_ytd (yield_ytd),
    INDEX idx_yields_1y (yield_1y),
    INDEX idx_yields_3y (yield_3y),
    INDEX idx_yields_5y (yield_5y)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci;

-- Fon geçmiş değerler tablosu
CREATE TABLE fund_historical_values (
    code VARCHAR(10),
    date DATE,
    value DECIMAL(10,6),
    aum DECIMAL(20,2),
    yield DECIMAL(10,4),
    cumulative_cashflow DECIMAL(20,2),
    investor_count INT,
    management_fee DECIMAL(5,2),     -- Yıllık Yönetim Ücreti (%)
    risk_value TINYINT,              -- Risk Değeri (1-7)
    purchase_value_day TINYINT,      -- Alış Valörü (gün)
    sale_value_day TINYINT,          -- Satış Valörü (gün)
    shares_total DECIMAL(20,2),      -- Toplam Adet
    shares_active DECIMAL(20,2),     -- Aktif Adet
    occupancy_rate DECIMAL(5,2),     -- Doluluk Oranı (%)
    market_share DECIMAL(5,2),       -- Pazar Payı (%)    
    PRIMARY KEY (code, date),
    FOREIGN KEY (code) REFERENCES funds(code),
    INDEX idx_date (date),
    INDEX idx_value (value),
    INDEX idx_code_value (code, value),
    INDEX idx_date_value (date, value),
    INDEX idx_code_date_value (code, date, value)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci;

-- Günlük istatistikler tablosu
CREATE TABLE daily_statistics (
    date DATE PRIMARY KEY,
    total_funds INT NOT NULL,
    total_companies INT NOT NULL,
    total_investors INT NOT NULL,
    total_aum DECIMAL(20,2) NOT NULL,
    avg_profit DECIMAL(10,4) NOT NULL,
    avg_loss DECIMAL(10,4) NOT NULL,
    INDEX idx_date (date)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci;

-- Enflasyon oranları tablosu
CREATE TABLE IF NOT EXISTS inflation_rates (
    date DATE PRIMARY KEY,
    monthly_rate DECIMAL(10,2) NOT NULL,
    yearly_rate DECIMAL(10,2) NOT NULL,
    INDEX idx_date (date)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci;