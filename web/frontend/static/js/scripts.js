
    // multiple datasets
    // -----------------
    /*
     var queryInput = $('.typeahead');
     var nbaTeams = new Bloodhound({
     datumTokenizer: Bloodhound.tokenizers.obj.whitespace('team'),
     queryTokenizer: Bloodhound.tokenizers.whitespace,
     remote: {
     url: "/api/search/",

     replace: function(url, query) {
     return url + query + "/";
     },
     ajax : {
     type: "POST",
     dataType: 'json',
     success: function (data) {
     $.each(data.users, function(){

     });
     }

     }
     }
     });

     var nhlTeams = new Bloodhound({
     datumTokenizer: Bloodhound.tokenizers.obj.whitespace('team'),
     queryTokenizer: Bloodhound.tokenizers.whitespace,
     prefetch: "{% static 'js/nhl.json' %}"
     });

     nbaTeams.initialize();
     nhlTeams.initialize();

     $('#multiple-datasets .typeahead').typeahead({
     highlight: true
     },
     {
     name: 'nba-teams',
     displayKey: 'name',
     source: nbaTeams.ttAdapter(),
     templates: {
     header: '<h4 class="league-name">NBA Teams</h4>'
     }
     },
     {
     name: 'nhl-teams',
     displayKey: 'team',
     source: nhlTeams.ttAdapter(),
     templates: {
     header: '<h4 class="league-name">NHL Teams</h4>'
     }
     });

     */

    var nbaTeams = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace('team'),
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        prefetch: '{% static 'js/nhl.json' %}'
    });

    var nhlTeams = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace('team'),
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        prefetch: '{% static 'js/nhl.json' %}'
    });

    nbaTeams.initialize();
    nhlTeams.initialize();

    $('#multiple-datasets .typeahead').typeahead({
                highlight: true
            },
            {
                name: 'nba-teams',
                displayKey: 'team',
                source: nbaTeams.ttAdapter(),
                templates: {
                    header: '<h3 class="league-name">NBA Teams</h3>'
                }
            },
            {
                name: 'nhl-teams',
                displayKey: 'team',
                source: nhlTeams.ttAdapter(),
                templates: {
                    header: '<h3 class="league-name">NHL Teams</h3>'
                }
            });

            $(function () {
        $('[data-toggle="popover"]').popover({
            placement: 'auto',
            html: true,
            trigger: 'hover'
        });
    });

    $(".submit").click(function () {
        var sender = $(this).attr('data-sender');
        var receiver = $(this).attr('data-receiver');
        $(this).removeClass("btn-primary");
        $(this).addClass("btn-default");
        $(this).text("Sent");
        $.ajax({
            url: "{% url 'api_add_friend' %}",
            type: "POST",
            data: 'sender=' + sender + "&receiver=" + receiver,
            dataType: "JSON",
            success: function (data) {

            },
            error: function (data) {
                console.log(data);
            }

        });

    });

     $(".accept-friend").click(function () {
        var sender = $(this).attr('data-sender');
        var receiver = $(this).attr('data-receiver');
        $(this).removeClass("btn-primary");
        $(this).addClass("btn-default");
        $(this).parent().parent().text(sender+"'s request is accepted");
        $.ajax({
            url: "{% url 'api_accept_friend' %}",
            type: "POST",
            data: 'sender=' + sender + "&receiver=" + receiver,
            dataType: "JSON",
            success: function (data) {

            },
            error: function (data) {
                console.log(data);
            }

        });

    });

 $(".reject-friend").click(function () {
        var sender = $(this).attr('data-sender');
        var receiver = $(this).attr('data-receiver');
        $(this).removeClass("btn-primary");
        $(this).addClass("btn-default");
        $(this).parent().parent().text(sender+"'s request is rejected");
        $.ajax({
            url: "{% url 'api_reject_friend' %}",
            type: "POST",
            data: 'sender=' + sender + "&receiver=" + receiver,
            dataType: "JSON",
            success: function (data) {

            },
            error: function (data) {
                console.log(data);
            }

        });

    });

    $(".create-event").click(function () {
        var event_name = $(".event-name").val();
        var start_time = $(".start_time").val();
        var owner = $(".owner").val();
        var restaurant = $(".restaurant").val();

        $(this).parent().parent().html("<h1>Event created!</h1>");
        $.ajax({
            url: "{% url 'api_create_event' %}",
            type: "POST",
            data: 'name=' + event_name + "&start_time=" + start_time + "&owner=" + owner + "&restaurant=" + restaurant,
            dataType: "JSON",
            success: function (data) {

            },
            error: function (data) {
                console.log(data);
            }

        });


    });


    $('#myMapModal').on('shown.bs.modal', function (e) {
        var map_options = {
            center: new google.maps.LatLng(41.048, 29.023),
            zoom: 11,
            draggable: false,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };

        var map = new google.maps.Map(document.getElementById("map_canvas"), map_options);
        var styles = [
            {
                featureType: "all",
                stylers: [
                    {saturation: -80}
                ]
            }, {
                featureType: "road.arterial",
                elementType: "geometry",
                stylers: [
                    {hue: "#00ffee"},
                    {saturation: 50}
                ]
            }, {
                featureType: "poi.business",
                elementType: "labels",
                stylers: [
                    {visibility: "off"}
                ]
            }
        ];

        map.setOptions({styles: styles});
        var defaultBounds = new google.maps.LatLngBounds(
                new google.maps.LatLng(-6, 106.6),
                new google.maps.LatLng(-6.3, 107)
        );


        var input = document.getElementById("keyword");
        var lat = document.getElementById("lat");
        var lng = document.getElementById("lng");
        var autocomplete = new google.maps.places.Autocomplete(input);
        autocomplete.bindTo("bounds", map);

        var marker = new google.maps.Marker({map: map});


        google.maps.event.addListener(autocomplete, "place_changed", function () {
            var place = autocomplete.getPlace();

            if (place.geometry.viewport) {
                map.fitBounds(place.geometry.viewport);
            } else {
                map.setCenter(place.geometry.location);
                map.setZoom(15);
            }

            marker.setPosition(place.geometry.location);

            lat.value = place.geometry.location.lat();
            lng.value = place.geometry.location.lng();
        });

        google.maps.event.addListener(map, "click", function (event) {
            marker.setPosition(event.latLng);
            marker.setMap(map);
            lat.value = event.latLng.lat();
            lng.value = event.latLng.lng();
        });
    });

$('.toggle-event-name').click(function () {
        $('.event-name').toggle();
    });
    $('.toggle-event-map').click(function () {
        $('.event-map').toggle();
    });
    $('.toggle-event-time').click(function () {
        $('.event-time').toggle();
    });

    $(function () {
        $('#datetimepicker1').datetimepicker({
            icons: {
                time: "fa fa-clock-o",
                date: "fa fa-calendar",
                up: "fa fa-arrow-up",
                previous: "fa fa-arrow-left",
                next: "fa fa-arrow-right",
                down: "fa fa-arrow-down"
            },
            format: 'YYYY-MM-DD H:m:s',
            minDate: moment()
        });
    });

     $('.dropdown-menu').click(function (event) {
        event.stopPropagation();
    });

var citynames = new Bloodhound({
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  prefetch: {
    url: "{% static 'js/citynames.json' %}",
    filter: function(list) {
      return $.map(list, function(cityname) {
        return { name: cityname }; });
    }
  }
});
citynames.initialize();

$('.participant').tagsinput({
  typeaheadjs: {
    name: 'citynames',
    displayKey: 'name',
    valueKey: 'name',
    source: citynames.ttAdapter()
  }
});