# Sinatra API for backend


## The base URL is
```
https://feeding-india.herokuapp.com
```

## Retrieve user info
Send <b>GET</b> in format
```
/:email
```
#### Possible replies
* Account does not exist:
```
does_not_exist
```
* Success
	*JSON in the form:
	```
	{
	  "email": "foo@xyz.com",
	  "name": "JohnDoe",
	  "phone": "800000",
	  "state": "The Shire",
	  "address": "Middle Earth",
	  "times_fed": * an integer value *
	}
	```


## Sign in
Send <b>POST</b> in format
```
/login/:email
```
#### Possible replies
* Account does not exist:
```
does_not_exist
```
* Success
	*JSON in the form:
	```
	{
	  "email": "foo@xyz.com",
	  "name": "JohnDoe",
	  "phone": "800000",
	  "state": "The Shire",
	  "address": "Middle Earth",
	  "times_fed": * an integer value *
	}
	```


## Sign up
Send <b>POST</b> in format
```
/feeders/:email
```
### Additional parameters
* ` name ` - User name. <b>Required</b>
* ` phone ` - User ph no. <b>Required</b>
* ` state ` - State in which located. <b>Required</b>
* ` address ` - Default address for food pickups. <b>Required</b>

#### Possible replies
* Insufficient parameters sent
```
insufficient_parameters
```
* Already exists
```
already_exists
```
* Success
	*JSON in the form:
	```
	{
	  "email": "foo@xyz.com",
	  "name": "JohnDoe",
	  "phone": "800000",
	  "state": "The Shire",
	  "address": "Middle Earth",
	  "times_fed": * an integer value *
	}
	```


## Donate
Send <b>POST</b> in format
```
/donation/:email
```
### Additional parameters
* ` url ` - URL to image. <b>Required</b>
* ` description ` - description/note. <b>Required</b>
* ` time ` - preferred pickup time. <b>Required</b>
* ` foodtype ` - veg/nonveg/both. <b>Required</b>
* ` packing ` - packaged/notpackaged/both. <b>Required</b>
* ` foodfor ` - number of people food will suffice for, roughly. <b>Required</b>
* ` location ` - Address, or geo-location. To use default address, don't send

#### Possible replies
* Insufficient parameters sent
```
insufficient_parameters
```
* Account does not exist:
```
does_not_exist
```
* Success
```
success
```


## Note
* Encode URL during requests
	* Encode unsafe characters like `&` , `%`, `/`, `=`, `space` etc
	* [Reference for encoding URL](http://www.w3schools.com/tags/ref_urlencode.asp)