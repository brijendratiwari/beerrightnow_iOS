//
//  Server.h
//  BeerRightNow
//
//  Created by Dragon on 3/28/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#ifndef BeerRightNow_Server_h
#define BeerRightNow_Server_h


#define API_URL @"http://www.beerrightnow.com/api/"

#define CHECK_ZIPCODE @"check_zipcode"
#define ADD_USER @"add_user"
#define ADD_ADDRESS @"add_address"
#define UPDATE_ADDRESS @"update_address"
#define USER_AUTH @"user_auth"
#define GET_PRODUCT_SECTIONS @"get_product_sections"
#define ORDER_DETAILS @"order_details"
#define ORDER_LIST @"order_list"
#define PLACE_ORDER @"place_order"
#define GET_PRODUCT_TYPE_ON_SECTION @"get_product_types_on_section"
#define GET_PRODUCT_BY_TYPE @"get_product_by_type"
#define PRODUCT_DETAILS @"product_details"
#define GET_CART @"get_cart"
#define GET_REVIEWS @"get_reviews"
#define CHECK_COUPON_CODE @"check_coupon_code"
#define GET_ADDRESS @"get_address"
#define GET_ADDRESSES @"get_addresses"
#define DELETE_ADDRESS @"delete_address"
#define GET_BRANDS @"get_brands"
#define GET_PRODUCERS @"get_producers"
#define GET_PRICE_RANGE @"get_price_range"
#define GET_TYPE @"get_style"
#define GET_STYLE_TYPE_NAME @"get_style_type_name"
#define SEARCH_RESULT @"search_result"
#define INVITE @"invite"
#define INVITE_TO_PARTY @"invite_to_party"
#define GET_DISTRIBUTOR_WORKING_HOUR @"distributor_working_hours"

#define REQUEST_URL(api) [NSString stringWithFormat:@"%@%@", API_URL, api]

#define STATUS @"status"
#define ERROR @"error"
#define MESSAGE @"message"
#define DATA @"data"

#define DISTRITUBTOR_ID @"distributor_id"
#define LRN_DISTRIBUTOR_ID @"lrn_distributor_id"
#define ZIP_CODE @"zipcode"
#define USER_INFO @"user_info"
#define CART @"cart"
#define DAY_NAME @"day_name"
#define IS_TODAY @"is_today"


#define CUSTOMER_ID @"customer_id"
#define ORDER_ID @"order_id"
#define SECTION_ID @"section_id"
#define TYPE_ID @"type_id"
#define PAGE @"page"

#define PRODUCT_ID @"product_id"
#define PRODUCT_COUNT @"product_count"

#endif
