___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "HQ revenue\u0027s Script",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Integrate booking intents from your site to HQ revenue's Performance Board.",
  "categories": [
    "ANALYTICS",
    "SALES",
  ],
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "organizationID",
    "displayName": "Organization ID (Get it with our support)",
    "simpleValueType": true
  },
  {
    "type": "GROUP",
    "name": "BookingParameters",
    "displayName": "Booking Parameters",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "TEXT",
        "name": "arrivalDate",
        "displayName": "Value of the arrival date",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "departureDate",
        "displayName": "Value of the departure date",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "adultCount",
        "displayName": "Number of adults",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "kidsCount",
        "displayName": "Number of children",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "roomCount",
        "displayName": "Number of rooms",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "hotelID",
        "displayName": "Identification of the selected hotel (Only for hotel chains)",
        "simpleValueType": true
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "ApplyDateTransformation",
    "displayName": "Should dates be formatted to ISO Standard? (YYYY-MM-DD)",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "transformDates",
        "checkboxText": "Yes, transform my dates.",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "convertFunction",
        "displayName": "Custom Javascript function to convert dates.",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "transformDates",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "helperParam",
        "displayName": "Second parameter to be sent to your conversion function. (Optional)",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "transformDates",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Enter your template code here.
const copyFromWindow = require('copyFromWindow');
const callInWindow = require('callInWindow');
const getType = require('getType');
const injectScript = require('injectScript');

// Check for HQ pick function in window
const hqFunction = copyFromWindow('nowHQ_gtm_pick');

// Get formatted date
function getDate(date){
  if(data.transformDates) {
    return data.convertFunction(date, data.helperParam);
  }

  return date;
}

/**
 * Executes The global function nowHQ_gtm_pick.
 * Makes use of the template parameters
 */
function executeHqPick(){
  const organization = data.organizationID;
  const hotel = data.hotelID;
  const arrival = getDate(data.arrivalDate);
  const departure = getDate(data.departureDate);
  const adults = data.adultCount;
  const kids = data.kidsCount;
  const rooms = data.roomCount;

  const postData = {
    hotelId: organization,
    arrivalDate: arrival,
    departureDate: departure,
    adultCount: adults,
    kidsCount: kids,
    roomCount: rooms,
    searchText: hotel,
  };

  const response = callInWindow('nowHQ_gtm_pick', postData);

  if(response) {
    data.gtmOnSuccess();
  } else {
    data.gtmOnFailure();
  }
}// executeHqPick

// Check in the hqFunction is available
if (!hqFunction) {
  injectScript(
    'https://script.nowhq.com/js/gtm/script.js',
    executeHqPick,
    data.gtmOnFailure,
    'nowHQpick'
  );
} else {
  // Execute script
  executeHqPick();
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "nowHQ_gtm_pick"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://script.nowhq.com/js/gtm/script.js"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: It should load the script if HQ's function is not available and call function
    with empty parameters
  code: "// Mocked template parameters\nconst mockData = {\n  organizationID: organization,\n\
    \  hotelID: '',\n  arrivalDate: '',\n  departureDate: '',\n  adultCount: '',\n\
    \  kidsCount: '',\n  roomCount: '',\n  transformDates: false,  \n};\n\n// Expected\
    \ values\nconst postData = {\n  hotelId: organization,\n  arrivalDate: '',\n \
    \ departureDate: '',\n  adultCount: '',\n  kidsCount: '',\n  roomCount: '',\n\
    \  searchText: '',\n};\n\n// Mock copyFromWindow API\nmock('copyFromWindow', function(objectInWindow)\
    \ {\n  assertThat(objectInWindow).isEqualTo(functionName);\n  return false;\n\
    });\n\n// Mock callInWindow API\nmock('injectScript', function(url, onSuccusses,\
    \ onFailure, cacheKey) {\n  assertThat(url).isEqualTo(scriptUrl);\n  assertThat(cacheKey).isEqualTo('nowHQpick');\n\
    \  onSuccusses();\n});\n\n// Mock callInWindow API\nmock('callInWindow', function(objectInWindow,\
    \ data) {\n  assertThat(objectInWindow).isEqualTo(functionName);\n  assertThat(data).isEqualTo(postData);\n\
    \  return true;\n});\n\n// Call runCode to run the template's code.\nrunCode(mockData);\n\
    \n// Verify that the tag finished successfully.\nassertApi('gtmOnSuccess').wasCalled();"
- name: It should call the function with parameters
  code: "// Mocked template parameters\nconst mockData = {\n  organizationID: organization,\n\
    \  hotelID: hotel,\n  arrivalDate: arrival,\n  departureDate: departure,\n  adultCount:\
    \ adults,\n  kidsCount: kids,\n  roomCount: rooms,\n  transformDates: false, \
    \ \n};\n\n// Expected values\nconst postData = {\n  hotelId: organization,\n \
    \ arrivalDate: arrival,\n  departureDate: departure,\n  adultCount: adults,\n\
    \  kidsCount: kids,\n  roomCount: rooms,\n  searchText: hotel,\n};\n\n// Mock\
    \ copyFromWindow API\nmock('copyFromWindow', function(objectInWindow) {\n  assertThat(objectInWindow).isEqualTo(functionName);\n\
    \  return false;\n});\n\n// Mock callInWindow API\nmock('injectScript', function(url,\
    \ onSuccusses, onFailure, cacheKey) {\n  assertThat(url).isEqualTo(scriptUrl);\n\
    \  assertThat(cacheKey).isEqualTo('nowHQpick');\n  onSuccusses();\n});\n\n// Mock\
    \ callInWindow API\nmock('callInWindow', function(objectInWindow, data) {\n  assertThat(objectInWindow).isEqualTo(functionName);\n\
    \  assertThat(data).isEqualTo(postData);\n  return true;\n});\n\n// Call runCode\
    \ to run the template's code.\nrunCode(mockData);\n\n// Verify that the tag finished\
    \ successfully.\nassertApi('gtmOnSuccess').wasCalled();"
- name: it should call function with formated dates
  code: "function mockedTransformFunction(date, pattern){\n  // Asserts that the pattern\
    \ was sent to the convertion function\n  assertThat(pattern).isEqualTo('DD/M/YY');\n\
    \  \n  if (date === '01/9/22') {\n    return '2022-09-01';\n  } else if (date\
    \ === '10/9/22') {\n    return '2022-09-10';\n  } else {\n    return '';\n  }\n\
    }\n\n\n// Mocked template parameters\nconst mockData = {\n  organizationID: organization,\n\
    \  hotelID: hotel,\n  arrivalDate: '01/9/22',\n  departureDate: '10/9/22',\n \
    \ adultCount: adults,\n  kidsCount: kids,\n  roomCount: rooms,\n  transformDates:\
    \ true,\n  helperParam: 'DD/M/YY',\n  convertFunction: mockedTransformFunction,\n\
    };\n\n// Expected values\nconst postData = {\n  hotelId: organization,\n  arrivalDate:\
    \ arrival,\n  departureDate: departure,\n  adultCount: adults,\n  kidsCount: kids,\n\
    \  roomCount: rooms,\n  searchText: hotel,\n};\n\n// Mock copyFromWindow API\n\
    mock('copyFromWindow', function(objectInWindow) {\n  assertThat(objectInWindow).isEqualTo(functionName);\n\
    \  return false;\n});\n\n// Mock callInWindow API\nmock('injectScript', function(url,\
    \ onSuccusses, onFailure, cacheKey) {\n  assertThat(url).isEqualTo(scriptUrl);\n\
    \  assertThat(cacheKey).isEqualTo('nowHQpick');\n  onSuccusses();\n});\n\n// Mock\
    \ callInWindow API\nmock('callInWindow', function(objectInWindow, data) {\n  assertThat(objectInWindow).isEqualTo(functionName);\n\
    \  assertThat(data).isEqualTo(postData);\n  return true;\n});\n\n// Call runCode\
    \ to run the template's code.\nrunCode(mockData);\n\n// Verify that the tag finished\
    \ successfully.\nassertApi('gtmOnSuccess').wasCalled();"
- name: It should use numeric values properly (cases for adultCount, kidsCount and
    roomCount)
  code: |-
    // Mocked template parameters
    const mockData = {
      organizationID: organization,
      hotelID: hotel,
      arrivalDate: arrival,
      departureDate: departure,
      adultCount: 2,
      kidsCount: 1,
      roomCount: 1,
      transformDates: false,
    };

    // Expected values
    const postData = {
      hotelId: organization,
      arrivalDate: arrival,
      departureDate: departure,
      adultCount: 2,
      kidsCount: 1,
      roomCount: 1,
      searchText: hotel,
    };

    // Mock copyFromWindow API
    mock('copyFromWindow', function(objectInWindow) {
      assertThat(objectInWindow).isEqualTo(functionName);
      return false;
    });

    // Mock callInWindow API
    mock('injectScript', function(url, onSuccusses, onFailure, cacheKey) {
      assertThat(url).isEqualTo(scriptUrl);
      assertThat(cacheKey).isEqualTo('nowHQpick');
      onSuccusses();
    });

    // Mock callInWindow API
    mock('callInWindow', function(objectInWindow, data) {
      assertThat(objectInWindow).isEqualTo(functionName);
      assertThat(data).isEqualTo(postData);
      return true;
    });

    // Call runCode to run the template's code.
    runCode(mockData);

    // Verify that the tag finished successfully.
    assertApi('gtmOnSuccess').wasCalled();
setup: |-
  const scriptUrl = 'https://script.nowhq.com/js/gtm/script.js';
  const functionName = 'nowHQ_gtm_pick';
  const organization = 'ABC';
  const hotel = 41;
  const arrival = '2022-09-01';
  const departure = '2022-09-10';
  const adults = '2';
  const kids = '1';
  const rooms = '1';


___NOTES___

Created on 01/09/2022, 20:07:40


