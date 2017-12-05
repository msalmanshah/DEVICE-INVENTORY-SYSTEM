(function() {
  'use strict';

  angular
    .module('k7')
    .controller('SubsController', SubsController)
    .filter('StatF', StatF)
    .service('PassData',PassData)


  function PassData() {
    this.msg = null;
    this.setmsg = function(msg) {
      return this.msg = msg;
    }
    this.getmsg = function() {
      return this.msg;
    }
  }


  function StatF() {
    return function(st) {
           if (st == 0) { return "NOT ACTIVE" }
      else if (st == 1) { return "ACTIVE"     }
      else if (st < 8 ) { return "SUSPENDED"  }
      else              { return "TERMINATED" }
    }
  }

  /** @ngInject */
  function SubsController($http,$state,$rootScope,$log,PassData) {

    var vm = this;

    vm.dbg = false;
    vm.log = "";

    //samplae data
    //vm.dta = {"hd":{"one":"Account","two":"SNO","tre":"Subscriber"},"rs":[{"one":"A101","two":"0101111183","tre":"JOHN CITIZEN"},{"one":"A101","two":"0101111184","tre":"JOHN CITIZEN"},{"one":"A101","two":"0101111185","tre":"JOHN CITIZEN"},{"one":"A101","two":"0101111189","tre":"JOHN CITIZEN"},{"one":"A102","two":"0101111181","tre":"MARY CITIZEN"},{"one":"A102","two":"0101111182","tre":"MARY CITIZEN"},{"one":"A102","two":"0101111188","tre":"MARY CITIZEN"},{"one":"A103","two":"0101111187","tre":"PAUL CITIZEN"},{"one":"A104","two":"0101111180","tre":"JANE CITIZEN"},{"one":"A104","two":"0101111186","tre":"JANE CITIZEN"}]};

    //for dropdown
    vm.ccodes = [{id:"ABW",name:"Aruba"}, {id:"AFG",name:"Afghanistan"}, {id:"AGO",name:"Angola"}, {id:"AIA",name:"Anguilla"}, {id:"ALA",name:"Åland Islands"}, {id:"ALB",name:"Albania"}, {id:"AND",name:"Andorra"}, {id:"ARE",name:"United Arab Emirates"}, {id:"ARG",name:"Argentina"}, {id:"ARM",name:"Armenia"}, {id:"ASM",name:"American Samoa"}, {id:"ATA",name:"Antarctica"}, {id:"ATF",name:"French Southern Territories"}, {id:"ATG",name:"Antigua and Barbuda"}, {id:"AUS",name:"Australia"}, {id:"AUT",name:"Austria"}, {id:"AZE",name:"Azerbaijan"}, {id:"BDI",name:"Burundi"}, {id:"BEL",name:"Belgium"}, {id:"BEN",name:"Benin"}, {id:"BES",name:"Bonaire, Sint Eustatius and Saba"}, {id:"BFA",name:"Burkina Faso"}, {id:"BGD",name:"Bangladesh"}, {id:"BGR",name:"Bulgaria"}, {id:"BHR",name:"Bahrain"}, {id:"BHS",name:"Bahamas"}, {id:"BIH",name:"Bosnia and Herzegovina"}, {id:"BLM",name:"Saint Barthélemy"}, {id:"BLR",name:"Belarus"}, {id:"BLZ",name:"Belize"}, {id:"BMU",name:"Bermuda"}, {id:"BOL",name:"Bolivia, Plurinational State of"}, {id:"BRA",name:"Brazil"}, {id:"BRB",name:"Barbados"}, {id:"BRN",name:"Brunei Darussalam"}, {id:"BTN",name:"Bhutan"}, {id:"BVT",name:"Bouvet Island"}, {id:"BWA",name:"Botswana"}, {id:"CAF",name:"Central African Republic"}, {id:"CAN",name:"Canada"}, {id:"CCK",name:"Cocos (Keeling) Islands"}, {id:"CHE",name:"Switzerland"}, {id:"CHL",name:"Chile"}, {id:"CHN",name:"China"}, {id:"CIV",name:"Côte d'Ivoire"}, {id:"CMR",name:"Cameroon"}, {id:"COD",name:"Congo, the Democratic Republic of the"}, {id:"COG",name:"Congo"}, {id:"COK",name:"Cook Islands"}, {id:"COL",name:"Colombia"}, {id:"COM",name:"Comoros"}, {id:"CPV",name:"Cabo Verde"}, {id:"CRI",name:"Costa Rica"}, {id:"CUB",name:"Cuba"}, {id:"CUW",name:"Curaçao"}, {id:"CXR",name:"Christmas Island"}, {id:"CYM",name:"Cayman Islands"}, {id:"CYP",name:"Cyprus"}, {id:"CZE",name:"Czech Republic"}, {id:"DEU",name:"Germany"}, {id:"DJI",name:"Djibouti"}, {id:"DMA",name:"Dominica"}, {id:"DNK",name:"Denmark"}, {id:"DOM",name:"Dominican Republic"}, {id:"DZA",name:"Algeria"}, {id:"ECU",name:"Ecuador"}, {id:"EGY",name:"Egypt"}, {id:"ERI",name:"Eritrea"}, {id:"ESH",name:"Western Sahara"}, {id:"ESP",name:"Spain"}, {id:"EST",name:"Estonia"}, {id:"ETH",name:"Ethiopia"}, {id:"FIN",name:"Finland"}, {id:"FJI",name:"Fiji"}, {id:"FLK",name:"Falkland Islands (Malvinas)"}, {id:"FRA",name:"France"}, {id:"FRO",name:"Faroe Islands"}, {id:"FSM",name:"Micronesia, Federated States of"}, {id:"GAB",name:"Gabon"}, {id:"GBR",name:"United Kingdom"}, {id:"GEO",name:"Georgia"}, {id:"GGY",name:"Guernsey"}, {id:"GHA",name:"Ghana"}, {id:"GIB",name:"Gibraltar"}, {id:"GIN",name:"Guinea"}, {id:"GLP",name:"Guadeloupe"}, {id:"GMB",name:"Gambia"}, {id:"GNB",name:"Guinea-Bissau"}, {id:"GNQ",name:"Equatorial Guinea"}, {id:"GRC",name:"Greece"}, {id:"GRD",name:"Grenada"}, {id:"GRL",name:"Greenland"}, {id:"GTM",name:"Guatemala"}, {id:"GUF",name:"French Guiana"}, {id:"GUM",name:"Guam"}, {id:"GUY",name:"Guyana"}, {id:"HKG",name:"Hong Kong"}, {id:"HMD",name:"Heard Island and McDonald Islands"}, {id:"HND",name:"Honduras"}, {id:"HRV",name:"Croatia"}, {id:"HTI",name:"Haiti"}, {id:"HUN",name:"Hungary"}, {id:"IDN",name:"Indonesia"}, {id:"IMN",name:"Isle of Man"}, {id:"IND",name:"India"}, {id:"IOT",name:"British Indian Ocean Territory"}, {id:"IRL",name:"Ireland"}, {id:"IRN",name:"Iran, Islamic Republic of"}, {id:"IRQ",name:"Iraq"}, {id:"ISL",name:"Iceland"}, {id:"ISR",name:"Israel"}, {id:"ITA",name:"Italy"}, {id:"JAM",name:"Jamaica"}, {id:"JEY",name:"Jersey"}, {id:"JOR",name:"Jordan"}, {id:"JPN",name:"Japan"}, {id:"KAZ",name:"Kazakhstan"}, {id:"KEN",name:"Kenya"}, {id:"KGZ",name:"Kyrgyzstan"}, {id:"KHM",name:"Cambodia"}, {id:"KIR",name:"Kiribati"}, {id:"KNA",name:"Saint Kitts and Nevis"}, {id:"KOR",name:"Korea, Republic of"}, {id:"KWT",name:"Kuwait"}, {id:"LAO",name:"Lao People's Democratic Republic"}, {id:"LBN",name:"Lebanon"}, {id:"LBR",name:"Liberia"}, {id:"LBY",name:"Libya"}, {id:"LCA",name:"Saint Lucia"}, {id:"LIE",name:"Liechtenstein"}, {id:"LKA",name:"Sri Lanka"}, {id:"LSO",name:"Lesotho"}, {id:"LTU",name:"Lithuania"}, {id:"LUX",name:"Luxembourg"}, {id:"LVA",name:"Latvia"}, {id:"MAC",name:"Macao"}, {id:"MAF",name:"Saint Martin (French part)"}, {id:"MAR",name:"Morocco"}, {id:"MCO",name:"Monaco"}, {id:"MDA",name:"Moldova, Republic of"}, {id:"MDG",name:"Madagascar"}, {id:"MDV",name:"Maldives"}, {id:"MEX",name:"Mexico"}, {id:"MHL",name:"Marshall Islands"}, {id:"MKD",name:"Macedonia, the former Yugoslav Republic of"}, {id:"MLI",name:"Mali"}, {id:"MLT",name:"Malta"}, {id:"MMR",name:"Myanmar"}, {id:"MNE",name:"Montenegro"}, {id:"MNG",name:"Mongolia"}, {id:"MNP",name:"Northern Mariana Islands"}, {id:"MOZ",name:"Mozambique"}, {id:"MRT",name:"Mauritania"}, {id:"MSR",name:"Montserrat"}, {id:"MTQ",name:"Martinique"}, {id:"MUS",name:"Mauritius"}, {id:"MWI",name:"Malawi"}, {id:"MYS",name:"Malaysia"}, {id:"MYT",name:"Mayotte"}, {id:"NAM",name:"Namibia"}, {id:"NCL",name:"New Caledonia"}, {id:"NER",name:"Niger"}, {id:"NFK",name:"Norfolk Island"}, {id:"NGA",name:"Nigeria"}, {id:"NIC",name:"Nicaragua"}, {id:"NIU",name:"Niue"}, {id:"NLD",name:"Netherlands"}, {id:"NOR",name:"Norway"}, {id:"NPL",name:"Nepal"}, {id:"NRU",name:"Nauru"}, {id:"NZL",name:"New Zealand"}, {id:"OMN",name:"Oman"}, {id:"PAK",name:"Pakistan"}, {id:"PAN",name:"Panama"}, {id:"PCN",name:"Pitcairn"}, {id:"PER",name:"Peru"}, {id:"PHL",name:"Philippines"}, {id:"PLW",name:"Palau"}, {id:"PNG",name:"Papua New Guinea"}, {id:"POL",name:"Poland"}, {id:"PRI",name:"Puerto Rico"}, {id:"PRK",name:"Korea, Democratic People's Republic of"}, {id:"PRT",name:"Portugal"}, {id:"PRY",name:"Paraguay"}, {id:"PSE",name:"Palestine, State of"}, {id:"PYF",name:"French Polynesia"}, {id:"QAT",name:"Qatar"}, {id:"REU",name:"Réunion"}, {id:"ROU",name:"Romania"}, {id:"RUS",name:"Russian Federation"}, {id:"RWA",name:"Rwanda"}, {id:"SAU",name:"Saudi Arabia"}, {id:"SDN",name:"Sudan"}, {id:"SEN",name:"Senegal"}, {id:"SGP",name:"Singapore"}, {id:"SGS",name:"South Georgia and the South Sandwich Islands"}, {id:"SHN",name:"Saint Helena, Ascension and Tristan da Cunha"}, {id:"SJM",name:"Svalbard and Jan Mayen"}, {id:"SLB",name:"Solomon Islands"}, {id:"SLE",name:"Sierra Leone"}, {id:"SLV",name:"El Salvador"}, {id:"SMR",name:"San Marino"}, {id:"SOM",name:"Somalia"}, {id:"SPM",name:"Saint Pierre and Miquelon"}, {id:"SRB",name:"Serbia"}, {id:"SSD",name:"South Sudan"}, {id:"STP",name:"Sao Tome and Principe"}, {id:"SUR",name:"Suriname"}, {id:"SVK",name:"Slovakia"}, {id:"SVN",name:"Slovenia"}, {id:"SWE",name:"Sweden"}, {id:"SWZ",name:"Swaziland"}, {id:"SXM",name:"Sint Maarten (Dutch part)"}, {id:"SYC",name:"Seychelles"}, {id:"SYR",name:"Syrian Arab Republic"}, {id:"TCA",name:"Turks and Caicos Islands"}, {id:"TCD",name:"Chad"}, {id:"TGO",name:"Togo"}, {id:"THA",name:"Thailand"}, {id:"TJK",name:"Tajikistan"}, {id:"TKL",name:"Tokelau"}, {id:"TKM",name:"Turkmenistan"}, {id:"TLS",name:"Timor-Leste"}, {id:"TON",name:"Tonga"}, {id:"TTO",name:"Trinidad and Tobago"}, {id:"TUN",name:"Tunisia"}, {id:"TUR",name:"Turkey"}, {id:"TUV",name:"Tuvalu"}, {id:"TWN",name:"Taiwan, Province of China"}, {id:"TZA",name:"Tanzania, United Republic of"}, {id:"UGA",name:"Uganda"}, {id:"UKR",name:"Ukraine"}, {id:"UMI",name:"United States Minor Outlying Islands"}, {id:"URY",name:"Uruguay"}, {id:"USA",name:"United States of America"}, {id:"UZB",name:"Uzbekistan"}, {id:"VAT",name:"Holy See (Vatican City State)"}, {id:"VCT",name:"Saint Vincent and the Grenadines"}, {id:"VEN",name:"Venezuela, Bolivarian Republic of"}, {id:"VGB",name:"Virgin Islands, British"}, {id:"VIR",name:"Virgin Islands, U.S."}, {id:"VNM",name:"Viet Nam"}, {id:"VUT",name:"Vanuatu"}, {id:"WLF",name:"Wallis and Futuna"}, {id:"WSM",name:"Samoa"}, {id:"YEM",name:"Yemen"}, {id:"ZAF",name:"South Africa"}, {id:"ZMB",name:"Zambia"}, {id:"ZWE",name:"Zimbabweco"} ];
    vm.setcc = "MYS";

    vm.selcc = function(cc) {
      vm.setcc = cc;
    }
 
    vm.clicksub = function(sno) {
      vm.selectedsno=sno;
      vm.log = sno;
      $state.go('subs.pst.x',{sn: sno});
    }

    vm.reset = function() {
      vm.crit = ""
      vm.look4("")
    }

    vm.look4 = function(crit) {

      vm.log = "";
      var c = crit;

      if (c == "") {
        c = "all";
      }

      vm.info = "Searching postpaid...";
      vm.srcst = "Searching postpaid...";

      $http.get("/api/nlook/4/"+c)
      .then(function(resp) {

        vm.len = resp.data.sz;
        vm.log += "[look4()] ["+c+"] got http.get results on,";
      
        if (resp.data.sz == 0) {
          vm.log += "[look4()] got sz==0, ";
          // check if looking for sno
          if (/^(6?0?11?[02-9])*\d{7}$/.test(c)) {
            vm.log += "[look4()] ["+c+"] sn-pat regex matches,";
            if (/^\d{7}$/.test(c))  { c = "010"+c; }
            else                    { c = c.replace(/^6?0?(11?)/,"0$1");}
            vm.log += "[look4()] ["+c+"] transformed";
            vm.selectedsno = c;
            vm.log += "[look4()] ["+c+"] its an sno, but not found, trying getppd() next,";
            vm.getppd(c);
          } else {
            // not sno, not found
            vm.log += "[look4()] ["+c+"] Postpaid Non SNO search, Not found"
            vm.selectedsno='';
            vm.srcst = "Not found [02]";
          }
        } else {
          vm.dta = resp.data;
          vm.srcst = vm.len + "Record(s)";
          vm.log += "[look4()] ["+c+"] got "+vm.srcst;
        }
          //vm.dta = resp.data;
      },
      function () {
        vm.log += "[look4()] ["+c+"] Error searching Postpaid";
        //alert("Not found [03]");
        vm.srcst = "Not found [03]";
      })
      .then(function(){
        vm.info="";
      });

    }

    vm.getppd = function(sno) {

      var url = "/api/ttsa/a/"+sno;

      vm.gotppd = false;
      vm.log += "[getppd()] ["+sno+"],";
      vm.srcst = "Searching prepaid...";

      $http.get(url)
      .then(function(resp) {
        vm.len = resp.data.length;
        if (resp.data.length==0) {
          vm.log += "[getppd()] ["+sno+"] Not found"
          vm.srcst = "Not found [00]";
        } else {
          PassData.setmsg(resp.data);
          vm.gotppd = true;
          vm.log += "[getppd()] ["+sno+"] got ppd,";
          vm.srcst = "Prepaid record found ";
          vm.dta = {};
          $state.go('subs.ppd.x',{sn: sno});
        }
      }, function () {
        vm.srcst = "Not found [01]";
        //alert("Not found [01]");
        vm.log += "[look4()] ["+sno+"] Error, Not found [01]";
      })
      .then(function() {
        vm.info = ""
      });
    }

    vm.log += "0. start";
    vm.look4("");

  }

})();
