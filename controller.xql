xquery version "3.0";

(: External variables available to the controller: :)
declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:root external;
declare variable $exist:prefix external;

(: Other variables :)
declare variable $home-page-url := "index.html";

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

(: Anything else, pass through: :)
else
    <ignore xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/> 
    </ignore>