<?php
/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Image search class
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
 * @version    CVS: $Id: news.php,v 1.5 2006/10/04 13:30:31 mj Exp $
 * @link       http://pear.php.net/package/Services_Yahoo
 */

require_once "AbstractSearch.php";

/**
 * News search class
 *
 * This class implements an interface to Yahoo's News search by using
 * the Yahoo API.
 *
 * @category   Services
 * @package    Services_Yahoo
 * @author     Martin Jansen <mj@php.net>
 * @copyright  2005-2006 Martin Jansen
 * @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
 * @version    CVS: $Id: news.php,v 1.5 2006/10/04 13:30:31 mj Exp $
 * @link       http://pear.php.net/package/Services_Yahoo
 * @link       http://developer.yahoo.net/news/V1/newsSearch.html
 */
class Services_Yahoo_Search_news extends Services_Yahoo_Search_AbstractSearch {

    protected $requestURL = "http://api.search.yahoo.com/NewsSearchService/V1/newsSearch";

    /** 
     * Set whether to sort articles by relevance or most-recent
     * 
     *
     * @access public
     * @param  string Sort type (either "rank" or "date")
     * @return Services_Yahoo_AbstractSearch Object which contains the method
     */
    public function sortedBy($sort)
    {
        $this->parameters['sort'] = $sort;

        return $this;
    }

    /**
     * Set the language the results are written in
     *
     * A list of supported languages can be found on
     * http://developer.yahoo.net/documentation/languages.html.
     *
     * @link   http://developer.yahoo.net/documentation/languages.html
     * @access public
     * @param  string Language code
     * @return Services_Yahoo_AbstractSearch Object which contains the method
     */
    public function inLanguage($language)
    {
        $this->parameters['language'] = $language;

        return $this;
    }
}
