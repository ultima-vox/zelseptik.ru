<?php

// Page doesn't accept subpages, 404 error
$oCore_Page = Core_Page::instance();
if ($oCore_Page->structure->getPath() != Core::$url['path'])
{
	$oCore_Page->error404();
}
else
{
	$oShop = Core_Entity::factory('Shop', Core_Page::instance()->libParams['shopId']);

	$Shop_Controller_Rss_Show = new Shop_Controller_Rss_Show($oShop);

	$Shop_Controller_Rss_Show
		->offset(Core_Page::instance()->libParams['begin'])
		->limit(Core_Page::instance()->libParams['count'])
		// Экспорт в Яндекс.Новости
		->yandex(Core_Page::instance()->libParams['yandexFullText'])
		// Выгрузка для Яндекс.Турбо
		->turbo(TRUE)
		// Счетчик системы статистики для учета посещаемости Турбо-страниц
		->channelEntities(
			array(
				array('name' => 'yandex:analytics', 'attributes' => array('type' => 'Yandex', 'id' => '53623984'))
			)
		)
		->group(Core_Page::instance()->libParams['shopGroupId'] == 0
			? FALSE
			: Core_Page::instance()->libParams['shopGroupId']
		)
		->stripTags(Core_Page::instance()->libParams['stripTags']);

	if (Core_Page::instance()->libParams['rssTitle'])
	{
		$Shop_Controller_Rss_Show
			->title(Core_Page::instance()->libParams['rssTitle']);
	}

	if (Core_Page::instance()->libParams['rssDescription'])
	{
		$Shop_Controller_Rss_Show
			->description(Core_Page::instance()->libParams['rssDescription']);
	}

	if (Core_Page::instance()->libParams['rssUrl'])
	{
		$Shop_Controller_Rss_Show
			->link(Core_Page::instance()->libParams['rssUrl']);
	}

	if (Core_Page::instance()->libParams['rssImage'])
	{
		$oSiteAlias = $oShop->Site->getCurrentAlias();
		if ($oSiteAlias)
		{
			$Shop_Controller_Rss_Show->image(array(
				'url' => Core_Page::instance()->libParams['rssImage'],
				'title' => $oShop->name,
				'link' => 'http://' . $oSiteAlias->name . '/'
			));
			
			if (Core_Page::instance()->libParams['yandexFullText'])
			{
				$Shop_Controller_Rss_Show->channelEntities = array_merge(
					$Shop_Controller_Rss_Show->channelEntities,
					array(
						array(
							'name' => 'yandex:logo',
							'value' => Core_Page::instance()->libParams['rssImage']
						),
						array(
							'name' => 'yandex:logo',
							'value' => Core_Page::instance()->libParams['rssImage'],
							'attributes' => array('type' => 'square')
						)
					)
				);
			}
		}
	}

	$Shop_Controller_Rss_Show->show();

	exit();
}