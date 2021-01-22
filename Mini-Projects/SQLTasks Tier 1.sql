/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT *
FROM `Facilities`
WHERE membercost >0
LIMIT 0 , 30

 facid 	monthlymain	name 	membercost 	guestcost 	initialoutlay 

    6 	80  	Squash Court 	3.5 	17.5 	5000
 	0 	200 	Tennis Court 1 	5.0 	25.0 	10000
 	1 	200 	Tennis Court 2 	5.0 	25.0 	8000
 	4 	3000 	Massage Room 1 	9.9 	80.0 	4000
 	5 	3000 	Massage Room 2 	9.9 	80.0 	4000


/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT( * )
FROM `Facilities`
WHERE membercost =0

COUNT(*) 	
4

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM `Facilities`
WHERE membercost <= ( .2 * monthlymaintenance ) 

facid 	monthlymain	name 	membercost 	guestcost 	initialoutlay
 	3 	10  	Table Tennis 	0.0 	5.0 	320
 	7 	15  	Snooker Table 	0.0 	5.0 	450
	8 	15  	Pool Table  	0.0  	5.0 	400
	2 	50  	Badminton Court 0.0 	15.5 	4000
	6 	80  	Squash Court 	3.5 	17.5 	5000
	0 	200 	Tennis Court 1 	5.0 	25.0 	10000
	1 	200 	Tennis Court 2 	5.0 	25.0 	8000
	4 	3000 	Massage Room 1 	9.9 	80.0 	4000
 	5 	3000 	Massage Room 2 	9.9 	80.0 	4000

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM `Facilities`
WHERE facid =1
OR facid =5
LIMIT 0 , 30

facid 	monthlymain	name 	membercost 	guestcost 	initialoutlay
    1 	200 	Tennis Court 2 	5.0 	25.0 	8000
	5 	3000 	Massage Room 2 	9.9 	80.0 	4000

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT `name` , `monthlymaintenance` ,
CASE
WHEN monthlymaintenance >100
THEN 'expensive'
WHEN monthlymaintenance <100
THEN 'cheap'
ELSE 'neither'
END AS $$$
FROM `Facilities`
LIMIT 0 , 30

    name        monthlymain   $$$
Tennis Court 1 	    200 	expensive
Tennis Court 2 	    200 	expensive
Badminton Court   	50  	cheap
Table Tennis    	10     	cheap
Massage Room 1  	3000 	expensive
Massage Room 2  	3000 	expensive
Squash Court    	80  	cheap
Snooker Table   	15  	cheap
Pool Table      	15  	cheap


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT MAX( joindate )
FROM `Members` 

MAX(joindate) 	
2012-09-26 18:08:45


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT b.facid, b.memid, f.name, CONCAT( m.firstname, ' ', m.surname ) AS fullname
FROM Bookings AS b
LEFT JOIN Members AS m ON b.memid = m.memid
LEFT JOIN Facilities AS f ON b.facid = f.facid
WHERE f.facid
IN ( 0, 1 )
LIMIT 0 , 30


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT b.facid, b.memid, f.name, f.guestcost, f.membercost, b.starttime AS date, CONCAT( m.firstname, ' ', m.surname ) AS fullname
FROM Bookings AS b
LEFT JOIN Members AS m ON b.memid = m.memid
LEFT JOIN Facilities AS f ON b.facid = f.facid
WHERE (SELECT f.guestcost, f.membercost FROM Facilities AS f WHERE f.guestcost > 30 OR f.membercost > 30)
AND
b.starttime >= '2012-09-14 00:00:00'
AND b.starttime <= '2012-09-14 23:59:59' 
AND f.guestcost > 30 
AND m.memid = 0
ORDER BY f.guestcost, f.membercost DESC


/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT b.facid, b.memid, f.name, f.guestcost, f.membercost, b.starttime AS date, CONCAT( m.firstname, ' ', m.surname ) AS fullname
FROM Bookings AS b
LEFT JOIN Members AS m ON b.memid = m.memid
LEFT JOIN Facilities AS f ON b.facid = f.facid
WHERE m.memid
IN (

SELECT f.facid
FROM Bookings AS b
LEFT JOIN Members AS m ON b.memid = m.memid
LEFT JOIN Facilities AS f ON b.facid = f.facid
WHERE f.guestcost >30
OR f.membercost >30
)
AND b.starttime >= '2012-09-14 00:00:00'
AND b.starttime <= '2012-09-14 23:59:59'
ORDER BY f.guestcost, f.membercost DESC
LIMIT 0 , 30

/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT b.facid, f.name, (
SUM(
CASE WHEN b.memid =0
THEN f.guestcost
ELSE 0
END ) + SUM(
CASE WHEN b.memid !=0
THEN f.membercost
ELSE 0
END )
) AS Revenue
FROM Bookings AS b
LEFT JOIN Facilities AS f ON b.facid = f.facid
WHERE 'Revenue' < 1000.0
GROUP BY b.facid
ORDER BY Revenue

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

SELECT CONCAT( m1.surname, ' ', m1.firstname ) AS name, CONCAT( m2.surname, ' ', m2.firstname ) AS recommendedby, m1.memid
FROM Members AS m1
INNER JOIN Members AS m2 ON m1.memid = m2.recommendedby
ORDER BY m1.surname

/* Q12: Find the facilities with their usage by member, but not guests */

SELECT COUNT(b.bookid), f.name
FROM Bookings AS b
LEFT JOIN Facilities AS f
    ON b.facid = f.facid
WHERE b.memid != 0 
GROUP BY b.facid

/* Q13: Find the facilities usage by month, but not guests */
SELECT COUNT( b.bookid ) , f.name, month( b.starttime )
FROM Bookings AS b
LEFT JOIN Facilities AS f ON b.facid = f.facid
WHERE b.memid !=0
GROUP BY b.facid, month( b.starttime )
ORDER BY month( b.starttime ) 