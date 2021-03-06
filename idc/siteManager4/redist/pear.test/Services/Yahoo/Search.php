<?php
/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Search dispatcher
 *
 * Copyright 2005-2006 Martin Jansen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * @category   Services
 * @package    Services_Yahoo
 * @author     Martin Jansen <mj@php.net>
 * @copyright  2005-2006 Martin Jansen
 * @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
 * @version    CVS: $Id: Search.php,v 1.5 2006/10/04 14:29:56 mj Exp $
 * @link       http://pear.php.net/package/Services_Yahoo
 */

require_once "Services/Yahoo/Exception.php";

/**
 * Search dispatcher class
 *
 * This class provides a method to create a concrete instance of one
 * of the supported search types (Web, Images, Videos, News, Local).
 *
 * @category   Services
 * @package    Services_Yahoo
 * @author     Martin Jansen <mj@php.net>
 * @copyright  2005-2006 Martin Jansen
 * @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
 * @version    CVS: $Id: Search.php,v 1.5 2006/10/04 14:29:56 mj Exp $
 */
class Services_Yahoo_Search {

    /**
     * Attempts to return a concrete instance of a search class
     *
     * @access  public
     * @param   string Type of search. Can be one of web, image, news, video or local
     * @return  object Concrete instance of a search class based on the paramter
     * @throws  Services_Yahoo_Exception
     */
    public function factory($type)
    {
        switch ($type) {

        case "web" :
        case "image" :
        case "news" :
        case "video" :
        case "local" :
            require_once "Services/Yahoo/Search/" . $type . ".php";
            $classname = "Services_Yahoo_Search_" . $type;
            return new $classname;

        default :
            throw new Services_Yahoo_Exception("Unknown search type {$type}");
        }
    }
}
