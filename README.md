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
Account does not exist
```
* Success
	- JSON in the form:
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
/login/:email/:password
```
#### Possible replies
* Account does not exist:
```
Account does not exist
```
* Authentication Error
```
Authentication Error
```
* Success
	- JSON in the form:
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
/feeders/:email/:password/:name/:phone/:state/:address
```
#### Possible replies
* Already exists
```
Sorry. You already have an account. Please Sign in
```
* Success
	- JSON in the form:
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
/donation/:email/:description/:time?url=image_URL_to_be_put_here
```
#### Possible replies
* No URL sent
```
No image url sent
```
* Account does not exist:
```
Account does not exist
```
* Success
```
Successful
```