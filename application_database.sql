DROP TABLE Free_Account;
DROP TABLE Paid_Account;
DROP TABLE Balance;
DROP TABLE Daily_Meal;
DROP TABLE Drink_Menu;
DROP TABLE Breakfast_Menu;
DROP TABLE Lunch_Menu;
DROP TABLE Dinner_Menu;
DROP TABLE Snack_Menu;
DROP TABLE Daily_Body_Weight;
DROP TABLE Exercise;
DROP TABLE Food_Delivery_Application;
DROP TABLE Food_Delivery_Online_Website;
DROP TABLE Food_Delivery_Phone_Call_Ordering;
DROP TABLE Food_Delivery_Purchase;
DROP TABLE Account;


CREATE TABLE Account (
AccountID DECIMAL(12) NOT NULL PRIMARY KEY,
UserName VARCHAR(64) NOT NULL,
FirstName VARCHAR(255) NOT NULL,
LastName VARCHAR(255) NOT NULL,
EncryptedPassword VARCHAR(64) NOT NULL,
Email VARCHAR(255) NOT NULL,
Gender VARCHAR(64) NOT NULL,
Height DECIMAL(3,2) NOT NULL,
MedicalHistory VARCHAR(1024) NOT NULL,
InitialBodyWeight DECIMAL(5,2) NOT NULL,
AimGoal VARCHAR(1024) NOT NULL,
CreatedTime TIMESTAMP NOT NULL,
AccountType CHAR(1) NOT NULL);


CREATE TABLE Free_Account (
AccountID DECIMAL(12) NOT NULL PRIMARY KEY,
FOREIGN KEY (AccountID) REFERENCES Account(AccountID));

CREATE TABLE Paid_Account (
AccountID DECIMAL(12) NOT NULL PRIMARY KEY,
AccountBalance DECIMAL(7,2) NOT NULL,
RenewalDate DATE NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Account(AccountID));

CREATE TABLE Breakfast_Menu (
BreakfastEatID DECIMAL(12) NOT NULL PRIMARY KEY,
BreakfastEat VARCHAR(1024) NOT NULL);


CREATE TABLE Lunch_Menu (
LunchEatID DECIMAL(12) NOT NULL PRIMARY KEY, 
LunchEat VARCHAR(1024) NOT NULL);


CREATE TABLE Dinner_Menu (
DinnerEatID DECIMAL(12) NOT NULL PRIMARY KEY,
DinnerEat VARCHAR(1024) NOT NULL);


CREATE TABLE Snack_Menu (
SnackID DECIMAL(12) NOT NULL PRIMARY KEY,
Snack VARCHAR(255) NOT NULL);


CREATE TABLE Drink_Menu (
DrinkID DECIMAL(12) NOT NULL PRIMARY KEY,
Drink VARCHAR(255) NOT NULL);


CREATE TABLE Daily_Meal (
DailyMealID DECIMAL(12) NOT NULL PRIMARY KEY,
AccountID DECIMAL(12) NOT NULL,
BreakfastTime TIMESTAMP NOT NULL,
BreakfastEatID DECIMAL(12) NOT NULL,
BreakfastDrinkID DECIMAL(12) NOT NULL,
LunchTime TIMESTAMP NOT NULL,
LunchEatID DECIMAL(12) NOT NULL,
LunchDrinkID DECIMAL(12) NOT NULL,
DinnerTime TIMESTAMP NOT NULL,
DinnerEatID DECIMAL(12) NOT NULL,
DinnerDrinkID DECIMAL(12) NOT NULL,
SnackTime TIMESTAMP NOT NULL,
SnackID DECIMAL(12) NOT NULL,
Water DECIMAL(12) NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
FOREIGN KEY (BreakfastEatID) REFERENCES Breakfast_Menu(BreakfastEatID),
FOREIGN KEY (BreakfastDrinkID) REFERENCES Drink_Menu(DrinkID),
FOREIGN KEY (LunchEatID) REFERENCES Lunch_Menu(LunchEatID),
FOREIGN KEY (LunchDrinkID) REFERENCES Drink_Menu(DrinkID),
FOREIGN KEY (DinnerEatID) REFERENCES Dinner_Menu(DinnerEatID),
FOREIGN KEY (DinnerDrinkID) REFERENCES Drink_Menu(DrinkID),
FOREIGN KEY (SnackID) REFERENCES Snack_Menu(SnackID));


CREATE TABLE Daily_Body_Weight (
DailyBodyWeightID DECIMAL(12) NOT NULL PRIMARY KEY,
AccountID DECIMAL(12) NOT NULL,
DailyBodyWeight DECIMAL(5,2) NOT NULL,
DailyBodyWeightDate TIMESTAMP NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Account(AccountID));

CREATE TABLE Exercise (
ExerciseID DECIMAL(12) NOT NULL PRIMARY KEY,
AccountID DECIMAL(12) NOT NULL,
ExerciseTaken VARCHAR(1024) NOT NULL,
ExerciseTakenTime DECIMAL(4,2) NOT NULL,
ExerciseDate TIMESTAMP NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Account(AccountID));


CREATE TABLE Balance (
BalanceID DECIMAL(12) NOT NULL PRIMARY KEY,
AccountID DECIMAL(12) NOT NULL,
BalanceDate DATE NOT NULL,
CaloriesBalance VARCHAR(1024) NOT NULL,
VitaminsBalance VARCHAR(1024) NOT NULL,
SugarIntakeBalance VARCHAR(1024) NOT NULL,
SaltIntakeBalance VARCHAR(1024) NOT NULL,
WaterIntakeBalance VARCHAR(1024) NOT NULL,
ExerciseBalance VARCHAR(1024) NOT NULL,
WeightBalance VARCHAR(1024) NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Account(AccountID));


CREATE TABLE Food_Delivery_Purchase (
FoodDeliveryID DECIMAL(12) NOT NULL PRIMARY KEY,
AccountID DECIMAL(12) NOT NULL,
FoodDelivery VARCHAR(1024) NOT NULL,
DrinkDelivery VARCHAR(255) NOT NULL,
DeliveryArrivingTime TIMESTAMP NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Account(AccountID));


CREATE TABLE Food_Delivery_Phone_Call_Ordering (
FoodDeliveryID DECIMAL(12) NOT NULL PRIMARY KEY,
FOREIGN KEY (FoodDeliveryID) REFERENCES Food_Delivery_Purchase(FoodDeliveryID));


CREATE TABLE Food_Delivery_Online_Website (
FoodDeliveryID DECIMAL(12) NOT NULL PRIMARY KEY,
WebsiteURL VARCHAR(1024) NOT NULL,
FOREIGN KEY (FoodDeliveryID) REFERENCES Food_Delivery_Purchase(FoodDeliveryID));


CREATE TABLE Food_Delivery_Application (
FoodDeliveryID DECIMAL(12) NOT NULL PRIMARY KEY,
ApplicationPath VARCHAR(1024)NOT NULL,
FOREIGN KEY (FoodDeliveryID) REFERENCES Food_Delivery_Purchase(FoodDeliveryID));

CREATE INDEX AccountCreatedTimeIdx ON  Account(CreatedTime);


CREATE TABLE Account_Change(
AccountChangeID DECIMAL(12) NOT NULL PRIMARY KEY,
OldAccountBalance DECIMAL(7,2) NOT NULL,
NewAccountBalance DECIMAL(7,2) NOT NULL,
PaidAccountID DECIMAL(12) NOT NULL,
AccountChangeDate DATE NOT NULL,
FOREIGN KEY (PaidAccountID) REFERENCES Paid_Account(AccountID));


CREATE TABLE Daily_Body_Weight_Change (
DailyBodyWeightChangeID DECIMAL(12) NOT NULL PRIMARY KEY,
DailyBodyWeightID DECIMAL(12) NOT NULL,
OldDailyBodyWeight DECIMAL(5,2) NOT NULL,
NewDailyBodyWeight DECIMAL(5,2) NOT NULL,
DailyBodyWeightChangeDate TIMESTAMP NOT NULL,
FOREIGN KEY (DailyBodyWeightID) REFERENCES Daily_Body_Weight(DailyBodyWeightID));


--Store Procedure
CREATE OR REPLACE PROCEDURE AddFreeAccount(AccountID IN DECIMAL, UserName IN VARCHAR, FirstName IN VARCHAR,
    LastName IN VARCHAR, EncryptedPassword IN VARCHAR, Email IN VARCHAR, Gender IN VARCHAR, Height IN DECIMAL,
    MedicalHistory IN VARCHAR, InitialBodyWeight IN DECIMAL, AimGoal IN VARCHAR)
AS
BEGIN
 INSERT INTO Account(AccountID, UserName, FirstName, LastName, EncryptedPassword, Email, Gender, Height,
    MedicalHistory, InitialBodyWeight, AimGoal, CreatedTime, AccountType)
 VALUES(AccountID, UserName, FirstName, LastName, EncryptedPassword, Email, Gender, Height,
    MedicalHistory, InitialBodyWeight, AimGoal?CURRENT_TIMESTAMP, 'F');

 INSERT INTO free_account(AccountID)
 VALUES(AccountID);
END;


CREATE OR REPLACE PROCEDURE AddPaidAccount(AccountID IN DECIMAL, UserName IN VARCHAR, FirstName IN VARCHAR,
    LastName IN VARCHAR, EncryptedPassword IN VARCHAR, Email IN VARCHAR, Gender IN VARCHAR, Height IN DECIMAL,
    MedicalHistory IN VARCHAR, InitialBodyWeight IN DECIMAL, AimGoal IN VARCHAR, AccountBalance IN DECIMAL, RenewalDate IN DATE)
AS
BEGIN
 INSERT INTO Account(AccountID, UserName, FirstName, LastName, EncryptedPassword, Email, Gender, Height,
    MedicalHistory, InitialBodyWeight, AimGoal, CreatedTime, AccountType)
 VALUES(AccountID, UserName, FirstName, LastName, EncryptedPassword, Email, Gender, Height,
    MedicalHistory, InitialBodyWeight, AimGoal?CURRENT_TIMESTAMP, 'P');

 INSERT INTO Paid_account(AccountID, AccountBalance, RenewalDate)
 VALUES(AccountID, AccountBalance, RenewalDate);
END;


CREATE OR REPLACE PROCEDURE AddDailyMeal(DailyMealID IN DECIMAL, AccountID IN DECIMAL, BreakfastTime IN TIMESTAMP,
    BreakfastEatID IN DECIMAL, BreakfastDrinkID IN DECIMAL, LunchTime IN TIMESTAMP, LunchEatID IN DECIMAL,
    LunchDrinkID IN DECIMAL, DinnerTime IN TIMESTAMP, DinnerEatID IN DECIMAL, DinnerDrinkID IN DECIMAL,
    SnackTime IN TIMESTAMP, SnackID IN DECIMAL, Water IN DECIMAL)
AS
BEGIN
 INSERT INTO Daily_Meal(DailyMealID, AccountID, BreakfastTime, BreakfastEatID, BreakfastDrinkID, LunchTime,
    LunchEatID, LunchDrinkID, DinnerTime, DinnerEatID, DinnerDrinkID,SnackTime, SnackID, Water)
 VALUES(DailyMealID, AccountID, BreakfastTime, BreakfastEatID, BreakfastDrinkID, LunchTime,
    LunchEatID, LunchDrinkID, DinnerTime, DinnerEatID, DinnerDrinkID,SnackTime, SnackID, Water);
END;


CREATE OR REPLACE PROCEDURE AddDailyBodyWeight(DailyBodyWeightID IN DECIMAL, AccountID IN DECIMAL,
    DailyBodyWeight IN DECIMAL)
AS
BEGIN
 INSERT INTO Daily_Body_Weight(DailyBodyWeightID, AccountID, DailyBodyWeight, DailyBodyWeightDate)
 VALUES(DailyBodyWeightID, AccountID, DailyBodyWeight, CURRENT_TIMESTAMP);
END;


CREATE OR REPLACE PROCEDURE AddExercise(ExerciseID IN DECIMAL, AccountID IN DECIMAL,
    ExerciseTaken IN VARCHAR, ExerciseTakenTime IN DECIMAL, ExerciseDate IN TIMESTAMP)
AS
BEGIN
 INSERT INTO Exercise(ExerciseID, AccountID, ExerciseTaken, ExerciseTakenTime, ExerciseDate)
 VALUES(ExerciseID, AccountID, ExerciseTaken, ExerciseTakenTime, ExerciseDate);
END;


--insert free account data
BEGIN
    addfreeaccount(1, 'LJ', 'Lingyan', 'Jiang', '9683', 'lingyanj@bu.edu', 'Female' , 5.4, 'penicillin allergy', 140, 'keep fit');
    addfreeaccount(2, 'BG', 'Bill', 'Gates', '1028', 'bg@gmail.com', 'Male' , 5.9, 'None', 154, 'Keep fit');
    addfreeaccount(3, 'JB', 'Jeff', 'Bezos', '0112', 'jbezos@amazon.com', 'Male' , 5.7, 'None', 154, 'Get married again');
    addfreeaccount(4, 'WB', 'Warren', 'Buffett', '0830', 'wb@gmail.com', 'Male' , 5.9, 'None', 190, 'Live forever');
    addfreeaccount(5, 'EM', 'Elon', 'Musk', '0628', 'em@gmail.com', 'Male' , 6.2, 'None', 180, 'To Space');
    COMMIT;
END;


--insert paid account data
BEGIN
    addpaidaccount(6, 'PC', 'Priscilla', 'Chan', '0224', 'pc@gmail.com', 'Female' , 5.5, 'None', 126, 'Lose weight', 50, CAST('11-DEC-2020' AS DATE));
    addpaidaccount(7, 'JM', 'Jack', 'Ma', '0910', 'jm@alibaba.com', 'Male' , 5.4, 'None', 130, 'Keep fit', 100, CAST('11-DEC-2020' AS DATE));
    addpaidaccount(8, 'RL', 'Richard', 'Liu', '0310', 'rl@jd.com', 'Male' , 6.0, 'None', 170, 'Keep Fit', 150, CAST('11-DEC-2020' AS DATE));
    COMMIT;
END;


--insert daily meal data
BEGIN
    adddailymeal(100, 1, timestamp '2020-12-11 09:22:23', 10002, 50005, timestamp '2020-12-11 12:22:23', 20003, 50001,
    timestamp '2020-12-11 18:22:23', 30004, 50003, timestamp '2020-12-11 20:22:23', 40002, 1200);
    adddailymeal(101, 2, timestamp '2020-12-11 10:22:23', 10008, 50005, timestamp '2020-12-11 13:15:23', 20005, 50001,
    timestamp '2020-12-11 19:52:28', 30010, 50004, timestamp '2020-12-11 11:15:23', 40001, 1000);
    adddailymeal(102, 3, timestamp '2020-12-11 08:10:23', 10007, 50004, timestamp '2020-12-11 11:45:33', 20004, 50002,
    timestamp '2020-12-11 20:30:33', 30001, 50006, timestamp '2020-12-11 16:12:23', 40002, 800);
    adddailymeal(103, 4, timestamp '2020-12-11 07:09:23', 10005, 50003, timestamp '2020-12-11 12:20:44', 20003, 50003,
    timestamp '2020-12-11 18:45:47', 30005, 50001, timestamp '2020-12-11 23:43:23', 40003, 900);
    adddailymeal(104, 5, timestamp '2020-12-11 06:43:23', 10006, 50002, timestamp '2020-12-11 12:36:55', 20002, 50006,
    timestamp '2020-12-11 19:02:43', 30007, 50007, timestamp '2020-12-11 10:22:23', 40004, 1500);
    adddailymeal(105, 6, timestamp '2020-12-11 11:21:23', 10003, 50001, timestamp '2020-12-11 14:35:17', 20001, 50003,
    timestamp '2020-12-11 21:01:01', 30009, 50008, timestamp '2020-12-11 19:22:23', 40005, 600);
    COMMIT;
END;


--insert daily body weight
BEGIN
    AddDailyBodyWeight(1001, 1, 141);
    AddDailyBodyWeight(1002, 2, 155);
    AddDailyBodyWeight(1003, 3, 155);
    AddDailyBodyWeight(1004, 4, 192);
    AddDailyBodyWeight(1005, 5, 182);
    AddDailyBodyWeight(1006, 6, 125);
    AddDailyBodyWeight(1007, 7, 131);
    AddDailyBodyWeight(1008, 8, 171);
    COMMIT;
END;


--insert exercise
BEGIN
    addexercise(2001, 1, 'walking', 60, timestamp '2020-12-11 07:00:23');
    addexercise(2002, 2, 'running', 20, timestamp '2020-12-11 09:00:23');
    addexercise(2003, 4, 'jogging', 30, timestamp '2020-12-11 10:00:23');
    addexercise(2004, 5, 'push-up', 15, timestamp '2020-12-11 14:00:23');
    addexercise(2005, 6, 'dancing', 30, timestamp '2020-12-11 09:00:23');
    COMMIT;
END;


--insert normal data
INSERT INTO Breakfast_Menu VALUES(10001, 'Garden Salad');
INSERT INTO Breakfast_Menu VALUES(10002, 'Fruit Salad');
INSERT INTO Breakfast_Menu VALUES(10003, 'Cereal');
INSERT INTO Breakfast_Menu VALUES(10004, 'Pancake');
INSERT INTO Breakfast_Menu VALUES(10005, 'Waffle');
INSERT INTO Breakfast_Menu VALUES(10006, 'Bagel');
INSERT INTO Breakfast_Menu VALUES(10007, 'Burrito');
INSERT INTO Breakfast_Menu VALUES(10008, 'Taco');
INSERT INTO Breakfast_Menu VALUES(10009, 'Croissant');

INSERT INTO Lunch_Menu VALUES(20001, 'Caesar Salad');
INSERT INTO Lunch_Menu VALUES(20002, 'Cheese Pizza');
INSERT INTO Lunch_Menu VALUES(20003, 'Panini');
INSERT INTO Lunch_Menu VALUES(20004, 'Sandwich');
INSERT INTO Lunch_Menu VALUES(20005, 'Meat Ball Pasta');

INSERT INTO Dinner_Menu VALUES(30001, 'Vegi Pizza');
INSERT INTO Dinner_Menu VALUES(30002, 'House Salad');
INSERT INTO Dinner_Menu VALUES(30003, 'Clam Chowder');
INSERT INTO Dinner_Menu VALUES(30004, 'Oyster');
INSERT INTO Dinner_Menu VALUES(30005, 'Mussels');
INSERT INTO Dinner_Menu VALUES(30006, 'Mac Cheese');
INSERT INTO Dinner_Menu VALUES(30007, 'Pork Chop');
INSERT INTO Dinner_Menu VALUES(30008, 'Rib Eye');
INSERT INTO Dinner_Menu VALUES(30009, 'New York Strip');
INSERT INTO Dinner_Menu VALUES(30010, 'Cheesecake');

INSERT INTO snack_menu VALUES(40001, 'Chocolate Bar');
INSERT INTO snack_menu VALUES(40002, 'Terra');
INSERT INTO snack_menu VALUES(40003, 'Mochi');
INSERT INTO snack_menu VALUES(40004, 'Jack Links');
INSERT INTO snack_menu VALUES(40005, 'Pudding');

INSERT INTO Drink_Menu VALUES(50001, 'Coffee');
INSERT INTO Drink_Menu VALUES(50002, 'Fresh Juice');
INSERT INTO Drink_Menu VALUES(50003, 'Tea');
INSERT INTO Drink_Menu VALUES(50004, 'Soft Drink');
INSERT INTO Drink_Menu VALUES(50005, 'Milk');
INSERT INTO Drink_Menu VALUES(50006, 'Soda');
INSERT INTO Drink_Menu VALUES(50007, 'Red Wine');
INSERT INTO Drink_Menu VALUES(50008, 'Beer');

--Trigger of History
create or replace NONEDITIONABLE TRIGGER AccountChangeTrigger
BEFORE UPDATE OF AccountBalance ON Paid_Account
FOR EACH ROW
BEGIN
     INSERT INTO Account_Change(AccountChangeID, OldAccountBalance, NewAccountBalance, PaidAccountID, AccountChangeDate)
     VALUES(NVL((SELECT MAX(AccountChangeID)+1 FROM Account_Change), 1),
        :OLD.AccountBalance,
        :NEW.AccountBalance,
        :New.AccountID,
        trunc(sysdate));
END;

UPDATE Paid_Account
SET accountbalance = 70
Where AccountID = 6;


CREATE OR REPLACE TRIGGER DailyBodyWeightChangeTrigger
BEFORE UPDATE OF DailyBodyWeight ON Daily_Body_Weight
FOR EACH ROW
BEGIN
     INSERT INTO Daily_Body_Weight_Change(DailyBodyWeightChangeID, DailyBodyWeightID, OldDailyBodyWeight,
        NewDailyBodyWeight, DailyBodyWeightChangeDate)
     VALUES(NVL((SELECT MAX(DailyBodyWeightChangeID)+1 FROM Daily_Body_Weight_Change), 1),
        :New.DailyBodyWeightID,
        :OLD.DailyBodyWeight,
        :NEW.DailyBodyWeight,
        trunc(CURRENT_TIMESTAMP));
END;

UPDATE Daily_Body_Weight
SET DailyBodyWeight = 139
Where AccountID = 1;


--Query
--choose the users who increase the weights from the initial weight
Select Account.accountid, (DAILY_BODY_WEIGHT.dailybodyweight - Account.initialbodyweight) as weight_change_from_begin
From Account
join daily_body_weight on Account.accountid = daily_body_weight.accountid
Where (DAILY_BODY_WEIGHT.dailybodyweight - Account.initialbodyweight) > 0
ORDER BY (DAILY_BODY_WEIGHT.dailybodyweight - Account.initialbodyweight)


--find the users whose weight is over 130lbs and take exercise time less than 30 mins and send email to those users
Select Account.accountid, DAILY_BODY_WEIGHT.dailybodyweight, account.email, Exercise.exercisetaken, Exercise.exercisetakentime
From Account
join daily_body_weight on Account.accountid = daily_body_weight.accountid
left join exercise on Account.accountid = exercise.accountid
Where((Exercise.exercisetakentime < 30 or Exercise.exercisetakentime is NULL) and DAILY_BODY_WEIGHT.dailybodyweight > 130)


--find user daily food and the user who like high-calorie food
Select account.accountid, Breakfast_menu.breakfasteat, daily_meal.breakfasttime, lunch_menu.luncheat, 
    daily_meal.lunchtime, dinner_menu.dinnereat, daily_meal.dinnertime, snack_menu.snack, daily_meal.snacktime
From daily_meal
join breakfast_menu on daily_meal.breakfasteatid = breakfast_menu.breakfasteatid
join lunch_menu on daily_meal.luncheatid = lunch_menu.luncheatid
join dinner_menu on daily_meal.dinnereatid = dinner_menu.dinnereatid
join snack_menu on daily_meal.snackid = snack_menu.snackid
right join account on account.accountid = daily_meal.accountid
where lunch_menu.luncheat = 'Cheese Pizza' or dinner_menu.dinnereat = 'Pork Chop' or dinner_menu.dinnereat = 'New York Strip' 
    or dinner_menu.dinnereat = 'Cheesecake'

