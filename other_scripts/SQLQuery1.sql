USE [master]
GO

/****** Object:  Database [DFNB2]    Script Date: 6/15/2020 3:06:54 PM ******/
CREATE DATABASE [DFNB2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DFNB2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\DFNB2.mdf' , SIZE = 1830912KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DFNB2_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\DFNB2_log.ldf' , SIZE = 2105344KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DFNB2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [DFNB2] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [DFNB2] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [DFNB2] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [DFNB2] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [DFNB2] SET ARITHABORT OFF 
GO

ALTER DATABASE [DFNB2] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [DFNB2] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [DFNB2] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [DFNB2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [DFNB2] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [DFNB2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [DFNB2] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [DFNB2] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [DFNB2] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [DFNB2] SET  DISABLE_BROKER 
GO

ALTER DATABASE [DFNB2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [DFNB2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [DFNB2] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [DFNB2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [DFNB2] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [DFNB2] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [DFNB2] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [DFNB2] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [DFNB2] SET  MULTI_USER 
GO

ALTER DATABASE [DFNB2] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [DFNB2] SET DB_CHAINING OFF 
GO

ALTER DATABASE [DFNB2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [DFNB2] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO

ALTER DATABASE [DFNB2] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [DFNB2] SET QUERY_STORE = OFF
GO

ALTER DATABASE [DFNB2] SET  READ_WRITE 
GO

