<?php
/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Video search class
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
 * @version    CVS: $Id: video.php,v 1.3 2006/10/02 12:53:34 mj Exp $
 * @link       http://pear.php.net/package/Services_Yahoo
 */

require_once "AbstractSearch.php";

/**
 * Video search class
 *
 * This class implements an interface to Yahoo's Video search by using
 * the Yahoo API.
 *
 * @category   Services
 * @package    Services_Yahoo
 * @author     Martin Jansen <mj@php.net>
 * @copyright  2005-2006 Martin Jansen
 * @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
 * @version    CVS: $Id: video.php,v 1.3 2006/10/02 12:53:34 mj Exp $
 * @link       http://pear.php.net/package/Services_Yahoo
 * @link       http://developer.yahoo.net/video/V1/videoSearch.html
 */
class Services_Yahoo_Search_video extends Services_Yahoo_Search_AbstractSearch {
    protected $requestURL = "http://api.search.yahoo.com/VideoSearchService/V1/videoSearch";
}
