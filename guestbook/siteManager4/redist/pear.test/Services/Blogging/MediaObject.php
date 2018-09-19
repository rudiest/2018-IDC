<?php
/**
* Media object (image, video, sound) in a blog entry.
* Not used currently.
*
* @category Services
* @package  Services_Blogging
* @author   Anant Narayanan <anant@php.net>
* @author   Christian Weiske <cweiske@php.net>
* @license  http://www.gnu.org/copyleft/lesser.html  LGPL License 2.1
* @link     http://pear.php.net/package/Services_Blogging
*/
class Services_Blogging_MediaObject
{
    const ERROR_INVALID_PROPERTY = 181;

    protected $values = array(
        'name'      => null,
        'mimetype'  => null,
        'filename'  => null
    );


    public function __set($strProperty, $value)
    {
        if (!isset($this->values[$strProperty])) {
            require_once 'Services/Blogging/Exception.php';
            throw new Services_Blogging_Exception(
                'Invalid property "' . $strProperty . '"',
                self::ERROR_INVALID_PROPERTY
            );
        }
        $this->values[$strProperty] = $value;
    }//public function __set($strProperty, $value)



    public function __get($strProperty)
    {
        if (!isset($this->values[$strProperty])) {
            require_once 'Services/Blogging/Exception.php';
            throw new Services_Blogging_Exception(
                'Invalid property "' . $strProperty . '"',
                self::ERROR_INVALID_PROPERTY
            );
        }
        return $this->values[$strProperty];
    }//public function __get($strProperty)

}//class Services_Blogging_MediaObject
?>