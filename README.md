# hqrevenue-script-template
HQ revenue's script template for Google Tag Manager integrations.

This template installs a script (located in https://script.nowhq.com/js/gtm/script.js) in your website via GTM. 
The script is simple and has the only task of executing a GET request to our server, as described bellow:

```http request
GET https://script.nowhq.com/pick
Content-Type: application/json

{ 
  hotelId: string,
  arrivalDate: dateIsoString,
  departureDate: dateIsoString,
  adultCount: number,
  kidsCount: number,
  roomCount: number,
  searchText: string,
}

Response 200
```

If a script load is a deal-breaker for you, check our HQ revenue's Pixel template.

## Introduction

The HQ revenue's Script template makes it easy for hotels, IBEs and OTAs to send booking intentions to HQ revenue's Performance Board.

## Step-by-Step example

Once you have GTM up and running, simply create a new tag, and search for our template in the community gallery.
Fill in the parameters needed, test the integration, and publish it.

### 1. Organization ID
You will get this value with our support or sales teams. It is a long identifier id for your organization.

### 2. Booking Variables
The booking variables are the information with the booking intent we want to measure.

1. Arrival date
2. Departure date
3. Number of adults
4. Number of children
5. Number of rooms
6. Hotel identification (only needed for hotel chains)

It is a good practice that these information should be represented in a DataLayer variable that could be easily given as
inputs for each related parameter.

### 3 Booking Dates Format - (Should dates be formatted to ISO Standard)

> IMPORTANT!
> If your system is already using dates according the ISO-8601 Standard, meaning, dates as 2022-12-25 to represent 25th of December 2022,
> you can skip this section and do not enable the checkbox "Yes, transform my dates"

HQ revenue's system works with date in ISO-8601 standards format, which means the dates should be formatted as YYYY-MM-DD.
Example: 2022-12-25.

If your system does not work with ISO date standards, you can use a Custom Javascript variable that can convert your data
format to ISO format and HQ revenue's Pixel template will execute it before sending the dates to our servers. Bellow you have
some tips on how to do it.

**1. Using a Custom Javascript Variable that reads values from the HTML**

Assuming a simple document body where the arrival and departure dates have in a span element in a non-ISO standard format:
```html
<body>
    <h1>Booking example</h1>
    <section>
      <span id="check-in">05 October 2022 14:00 UTC</span>
      <span id="check-out">10 October 2022 12:00 UTC</span>

      <button>Book Now</button>
    </section>
  </body>
```

You can create two dedicated Custom Javascript variables in GTM, and assign a very simple script to them Note that the
id of the elements must change for each function implementation.

```javascript
/**
 * Convert date information from selected element to ISO Standard.
 */
function(){
  var dateText = document.getElementById('date-1').textContent;
  
  if(!dateText) {
    return '';
  }
  
  return new Date(dateText).toISOString();
}
```

**1. Using a Custom Javascript Variable as a function**

You can create a generic date conversion function as a Custom Javascript variable and give it to HQ revenue's to execute
the conversion before sending the data. For this case, enable the "Yes, transform my date" checkbox, add your function in
the field "Custom Javascript function to convert dates."

The second parameter is optional. It will be sent to you function, as a second parameter. I can be useful as a helper,
for example, as a regular expressions pattern.

```javascript
function(){
    return function(date, secondParameter) {
        return new Date(date).toISOString();
    }
}
```

In case you need a generic conversion example, we offer the code snippet bellow. It makes use of regular expressions for
date conversion. It is not the most performant, you are advised to prune this function for your specific case, since it
is very generic.

For this example to work, you need to pass as a second parameter, the information of how is your date information formatted.

For example, if your dates are represented as 12/25/22, the second parameter should be MM/DD/YY.

```javascript
/**
 * Parse the `dateString` (that is based in the `format` parameter) to ISO Strings.
 * 
 * Eg: 
 * To format 12/25/22 into 2022-12-25T00:00:00.000Z:
 * parseDateFormat("12/25/22", "MM/DD/YY")
 *
 * Your date's format description. In ISO duration, eg: DD.MM.YYYY, or MM.DD.YY
 * 
 * @param dateString  String with the date to be formated
 * @param format      Date Format using ISO Duration designators
 * @return {string}
 */
function() {
  return function(dateString, format) {
    var isoString = '';
    var result = format.match(/([YMD]{1,4})(.|\/|-)([YMD]{1,4})?(.|\/|-)([YMD]{1,4})/);

    var test = result
        .filter(function(item, index){ return index !== 0 })
        .map(function(item) {
            switch (item) {
                case 'D':
                    return '(?<day>\\d{1})';
                case 'DD':
                    return '(?<day>\\d{2})';
                case 'M':
                    return '(?<month>\\d{1})';
                case 'MM':
                    return '(?<month>\\d{2})';
                case 'YY':
                    return '(?<year>\\d{2})';
                case 'YYYY':
                    return '(?<year>\\d{4})';
                default:
                    return '\\'+item;
            }
        })
        .join('');

    var match = new RegExp('^'+test+'$').exec(dateString);

    if (match) {
        var year = match.groups.year.charAt(2) ? match.groups.year : ("20"+match.groups.year)
        var month = match.groups.month.charAt(1) ? match.groups.month : ("0"+match.groups.month)
        var day = match.groups.day.charAt(1) ? match.groups.day : ("0"+match.groups.day)
        isoString = year+'-'+month+'-'+day+'T00:00:00.000Z'
    } else {
      isoString = dateString
    }
    
    return isoString;
  }
}
```

## About General Data Protection Regulation (GDRP)

The booking intent information does not fall in GDRP, because HQ revenue does not apply any user identification method.
Our goal is to evaluate the intentions of your users, but not to identify them.

Though HQ revenue does not use any tracking method Google Tag Manager, or browser's extensions, can disable our script based
on user's preferences.
