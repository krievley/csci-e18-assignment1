xquery version "3.0";

let $station_id := request:get-parameter('station_id','')
let $url := doc(concat('http://weather.gov/xml/current_obs/',$station_id,'.xml'))
return $url