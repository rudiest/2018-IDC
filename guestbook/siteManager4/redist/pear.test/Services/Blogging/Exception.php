<?php
/**
* Exception class for the Services_Blogging package.
* Extends the normal exception class to make it easy
* to distinguish between blogging and other exceptions
* via instanceof
*
* @category Services
* @package  Services_Blogging
* @author   Anant Narayanan <anant@php.net>
* @author   Christian Weiske <cweiske@php.net>
* @license  http://www.gnu.org/copyleft/lesser.html  LGPL License 2.1
* @link     http://pear.php.net/package/Services_Blogging
*/
class Services_Blogging_Exception extends Exception
{
    public function __construct($message = null, $code = 0)
    {
        parent::__construct($message, intval($code));
    }//public function __construct($message = null, $code = 0)
}//class Services_Blogging_Exception extends Exception
?>