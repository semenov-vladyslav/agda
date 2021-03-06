-- All 256 ASCII characters

module LineEndings.LexASCII where

{- In Block comment:

Control characters 0-31

 


Rest of 7-bit ASCII

 !"#$%&'()*+,-./0123456789:;<=>?
@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_
`abcdefghijklmnopqrstuvwxyz{|}~

8-Bit ASCII






 ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿
ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞß
àáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ

-}

-- In line comments

--  
-- 
-- 

--  !"#$%&'()*+,-./0123456789:;<=>?
-- @ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_
-- `abcdefghijklmnopqrstuvwxyz{|}~

-- 

-- Note: Agda translates the following character (decimal: 133 xd: x85)
-- into a new line, see function convertLineEndings.

-- 

-- 
-- 
-- 
-- 

--  ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿
-- ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞß
-- àáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ

-- -}
