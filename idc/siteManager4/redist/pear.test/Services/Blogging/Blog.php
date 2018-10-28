<?php
/**
* Blog object. Used when multiple blogs are supported by
* one account.
*
* @category Services
* @package  Services_Blogging
* @author   Anant Narayanan <anant@php.net>
* @author   Christian Weiske <cweiske@php.net>
* @license  http://www.gnu.org/copyleft/lesser.html  LGPL License 2.1
* @link     http://pear.php.net/package/Services_Blogging
* @see      Services_Blogging_MultipleBlogsInterface
*/
class Services_Blogging_Blog
{
    const ERROR_INVALID_PROPERTY = 181;

    protected $values = array(
        'id'    => null,
        'name'  => null,
        'url'   => null
    );



    public function __construct($id = null, $name = null, $url = null)
    {
        $this->id   = $id;
        $this->name = $name;
        $this->url  = $url;
    }//public function __construct($id = null, $name = null, $url = null)



    public function __set($strProperty, $value)
    {
        /*
        if (!isset($this->values[$strProperty])) {
            require_once 'Services/Blogging/Exception.php';
            var_dump($this->values);
            echo 'Invalid property "' . $strProperty . '"';
            throw new Services_Blogging_Exception(
                'Invalid property "' . $strProperty . '"',
                self::ERROR_INVALID_PROPERTY
            );
        }
        */
        $this->values[$strProperty] = $value;
    }//public function __set($strProperty, $value)



    public function __get($strProperty)
    {
        /*
        if (!isset($this->values[$strProperty])) {
            require_once 'Services/Blogging/Exception.php';
            throw new Services_Blogging_Exception(
                'Invalid property "' . $strProperty . '"',
                self::ERROR_INVALID_PROPERTY
            );
        }
        */
        return $this->values[$strProperty];
    }//public function __get($strProperty)

}//class Services_Blogging_Blog
?>