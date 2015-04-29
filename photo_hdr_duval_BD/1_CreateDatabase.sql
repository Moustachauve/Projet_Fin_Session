-- Simon Lemonnier
USE master
CREATE DATABASE [H15_PROJET_E05]
	ON PRIMARY(
		NAME='photo_hdr_Duval',
		FILENAME = 'C:\Espace Labo\SQLData\photo_hdr_Duval.mdf',
		SIZE=10MB,
		MAXSIZE=20,
		FILEGROWTH=10%)
	LOG ON(
		NAME='photo_hdr_Duval',
		FILENAME = 'C:\Espace Labo\SQLLog\photo_hdr_Duval.ldf',
		SIZE=10MB,
		MAXSIZE=200,
		FILEGROWTH=20%);