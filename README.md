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
/login/:email
```
#### Possible replies
* Account does not exist:
```
does_not_exist
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
/feeders/:email/:name/:phone/:state/:address
```
#### Possible replies
* Already exists
```
already_exists
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
/donation/:email/:description/:time
```
### Additional parameters
* ``` url ``` - URL to image. <b>Required</b>
* ``` foodtype ``` - veg/nonveg/both. <b>Required</b>
* ``` packing ``` - packaged/notpackaged/both. <b>Required</b>
* ``` foodfor ``` - number of people food will suffice for, roughly. <b>Required</b>
* ``` location ``` - Address, or geo-location. To use default address, don't send

#### Possible replies
* No URL sent
```
no_img_url
```
* Account does not exist:
```
does_not_exist
```
* Success
```
success
```
