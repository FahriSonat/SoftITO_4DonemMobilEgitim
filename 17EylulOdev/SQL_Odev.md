

CREATE TABLE Bolum (
    BolumID     INT PRIMARY KEY IDENTITY(1,1),
    BolumAdi    VARCHAR(100) NOT NULL UNIQUE
    );


    CREATE TABLE Ogrenci (
    OgrenciID   INT PRIMARY KEY IDENTITY(1,1),
    Ad          VARCHAR(50) NOT NULL,
    Soyad       VARCHAR(50) NOT NULL,
    Email       VARCHAR(100) UNIQUE,
    BolumID     INT NOT NULL,
    CONSTRAINT FK_Ogrenci_Bolum FOREIGN KEY (BolumID)
        REFERENCES Bolum(BolumID)
);


CREATE TABLE Ders (
    DersID      INT PRIMARY KEY IDENTITY(1,1),
    DersAdi     VARCHAR(100) NOT NULL,
    Kredi       INT NOT NULL CHECK (Kredi > 0),
    BolumID     INT NOT NULL,
    CONSTRAINT FK_Ders_Bolum FOREIGN KEY (BolumID)
        REFERENCES Bolum(BolumID)
);

CREATE TABLE Ogrenci_Ders (
    OgrenciID   INT NOT NULL,
    DersID      INT NOT NULL,
    Not_        DECIMAL(5,2),
    KayitTarihi DATE DEFAULT GETDATE(),
    CONSTRAINT PK_Ogrenci_Ders PRIMARY KEY (OgrenciID, DersID),
    CONSTRAINT FK_OD_Ogrenci FOREIGN KEY (OgrenciID)
        REFERENCES Ogrenci(OgrenciID),
    CONSTRAINT FK_OD_Ders FOREIGN KEY (DersID)
        REFERENCES Ders(DersID)
);

