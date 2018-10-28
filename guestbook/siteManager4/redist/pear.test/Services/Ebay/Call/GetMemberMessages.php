<?PHP
/**
 * Get the logo URL
 *
 * $Id: GetMemberMessages.php,v 1.2 2005/01/11 23:51:28 luckec Exp $
 *
 * @package Services_Ebay
 * @author  Carsten Lucke <luckec@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/api_doc/Functions/GetMemberMessages/getmembermessageslogic.htm
 * @todo    perhaps this should be split into two wrapper-calls: GetMemberMessagesByItemId, GetMemberMessagesByDateRange
 */
class Services_Ebay_Call_GetMemberMessages extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetMemberMessages';

   /**
    * arguments of the call
    *
    * @var  array
    */
    protected $args = array(
                            'MessageType' => 1
                        );

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'StartCreationDate',
                                 'EndCreationDate',
                                 'ItemId',
                                 'MessageType',
                                 'DisplayToPublic',
                                 'Pagination',
                                 'MessageStatus'
                                );
 
   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $return = parent::call($session);
        $result = Services_Ebay::loadModel('MemberMessageList', $return, $session);
        return $result;
    }
}
?>