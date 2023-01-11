package kr.co.infovine.dkmm.db.model.store;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class TStoreGooglePlaceModel {

	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.place_id
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String placeId;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.store_mngt_no
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private int storeSeq;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.name
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String name;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.latitude
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String latitude;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.longitude
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String longitude;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.viewport_northeast_latitude
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String viewportNortheastLatitude;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.viewport_northeast_longitude
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String viewportNortheastLongitude;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.viewport_southwest_latitude
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String viewportSouthwestLatitude;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.viewport_southwest_longitude
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String viewportSouthwestLongitude;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.icon
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String icon;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.icon_background_color
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String iconBackgroundColor;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.icon_mask_base_uri
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String iconMaskBaseUri;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.reference
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String reference;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.types
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String types;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.rating
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String rating;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.price_level
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String priceLevel;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.user_ratings_total
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String userRatingsTotal;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.vicinity
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private String vicinity;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.ins_dt
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private Date insDt;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.upt_dt
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private Date uptDt;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_google_place.map_dt
	 * @mbg.generated  Wed Sep 14 15:13:28 KST 2022
	 */
	private Date mapDt;

	private String formattedAddress;
}