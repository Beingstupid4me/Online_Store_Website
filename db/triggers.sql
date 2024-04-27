/*
    This file contains the triggers for the database.
    The triggers are used to enforce the business rules of the database.
*/


--Trigger to check the number of failed login attempts and ban the customer if the number of failed attempts exceeds 3
DELIMITER $$
CREATE TRIGGER CheckFailedLoginAttempts
AFTER INSERT ON Login_History
FOR EACH ROW
BEGIN
    DECLARE failed_attempts INT;
    SELECT COUNT(*)
    INTO failed_attempts
    FROM Login_History
    WHERE CutomerNumberUsed = NEW.CutomerNumberUsed
        AND isSuccess = false
        AND DateTime_Attempt >= DATE_SUB(NOW(), INTERVAL 24 HOUR);
	

    -- Raise an error if the number of failed attempts exceeds 3
    IF failed_attempts >= 3  THEN
		UPDATE Customers
		SET isBanned = true
		WHERE CustomerNumber = new.CutomerNumberUsed;
    END IF;
END;


DELIMITER;


--Trigger to update the Average-Price in the Product table upon insertion in Inventory

DELIMITER $$
CREATE TRIGGER update_avg_price_after_insert
AFTER INSERT ON Inventory
FOR EACH ROW
BEGIN
 DECLARE AVG_PRICE_FOR_PRODUCT DECIMAL(10,2);
 DECLARE TOT_QUAN INT;
 DECLARE MOST_RECENT_EXPIRY DATE;
 SELECT AVG(Price), SUM(Quantity_on_Hand), MAX(Recent_date_of_expiry) INTO AVG_PRICE_FOR_PRODUCT, TOT_QUAN, MOST_RECENT_EXPIRY
 FROM Inventory
 WHERE ProductID = NEW.ProductID;
UPDATE Products
SET Average_Price = AVG_PRICE_FOR_PRODUCT, Total_Quantity = TOT_QUAN, Recent_date_of_expiry = MOST_RECENT_EXPIRY
WHERE ProductID = NEW.ProductID;
END $$
DELIMITER ;
