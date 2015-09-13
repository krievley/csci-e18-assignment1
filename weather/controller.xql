xquery version "3.0";

(: External variables available to the controller: :)
declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:root external;
declare variable $exist:prefix external;

(: Function to get the extension of a filename: :)
declare function local:get-extension($filename as xs:string) as xs:string {
    let $name := replace($filename, ".*[/\\]([^/\\]+)$", "$1")
    return
        if(contains($name, "."))
        then replace($name, ".*\.([^\.]+)$", "$1")
        else ""
};
(: Function to get the name w/o extension of a filename: :)
declare function local:get-filename-without-extension($filename as xs:string) as xs:string {
    let $name := replace($filename, ".*[/\\]([^/\\]+)$", "$1")
    return
        if(contains($name, "."))
        then replace($name, "(.*)\.([^\.]+)$", "$1")
        else $name
};

(: Other variables :)
declare variable $home-page-url := "index";

(: If trailing slash is missing, put it there and redirect :)
if($exist:path eq "") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{request:get-uri()}/"/>
    </dispatch> 
    
(: If there is no resource specified, go to the home page.
This is a redirect, forcing the browser to perform a redirect. So this request
will pass through the controller again... :)
else if($exist:resource eq "") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{$home-page-url}"/>
    </dispatch>
else if($exist:resource eq 'index') then
     <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="index.html"/>
    </dispatch>   
else if($exist:resource eq 'stations') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, '/data/stations_international_airports.xml')}"/>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, "/xsl/station_list.xsl")}"/>
            </forward>
        </view>
    </dispatch>      
else if(local:get-extension($exist:resource) eq 'html' ) then
    let $station_id := local:get-filename-without-extension($exist:resource)
    return 
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, '/xq/get_weather_data.xq')}" >
            <add-parameter name="station_id" value="{$station_id}"/>
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, "/xsl/weather.xsl")}"/>
            </forward>
        </view>
    </dispatch>  
(: Anything else, pass through: :)
else
    <ignore xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/> 
    </ignore>