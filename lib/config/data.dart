/// filter type items
List filterTypeItems = [
  ['Sell', 'filter.lbl_for_sale'],
  ['Rent', 'filter.lbl_for_rent']
];

List filterItems = [
  ['Sell', 'filter.lbl_buy'],
  ['Rent', 'filter.lbl_rent']
];

List purposeTypeItems = [
  ['residential', 'filter.lbl_residential'],
  ['commercial', 'filter.lbl_commercial'],
];

List completionTypeItems = [
  ['Ready', 'addproperty.lbl_ready_to_move_in'],
  ['Off-plan', 'addproperty.lbl_under_construnction']
];

List cityArray = [
  'ALL_CITIES',
  'ABU_DHABI',
  'DUBAI',
  'SHARJAH',
  'AJMAN',
  'UMM_AL_QUWAIN',
  'RAS_AL_KHAIMAH',
  'FUJAIRAH',
  'AL_AIN',
];

List cityArrayNew = [
  'cityArrayNew.SELECT_CITY',
  'cityArrayNew.ABU_DHABI',
  'cityArrayNew.AL_AIN',
  'cityArrayNew.DUBAI',
  'cityArrayNew.SHARJAH',
  'cityArrayNew.AJMAN',
  'cityArrayNew.RAS_AL_KHAIMAH',
  'cityArrayNew.FUJAIRAH',
  'cityArrayNew.UMM_AL_QUWAIN',
];

List cityArrayChoice = [
  ['All Cities', 'cityArray.ALL_CITIES', '0'],
  ['Abu Dhabi', 'cityArray.ABU_DHABI', '1'],
  ['Dubai', 'cityArray.DUBAI', '3'],
  ['Sharjah', 'cityArray.SHARJAH', '44'],
  ['Ajman', 'cityArray.AJMAN', '31'],
  ['Umm Al Quwain', 'cityArray.UMM_AL_QUWAIN', '212'],
  ['Ras Al Khaimah', 'cityArray.RAS_AL_KHAIMAH', '69'],
  ['Fujairah', 'cityArray.FUJAIRAH', '78'],
  ['Al Ain', 'cityArray.AL_AIN', '18'],
];

List selectOneCity = [
  ['Select City', 'cityArrayNew.SELECT_CITY', '0'],
  ['Abu Dhabi', 'cityArray.ABU_DHABI', '1'],
  ['Dubai', 'cityArray.DUBAI', '3'],
  ['Sharjah', 'cityArray.SHARJAH', '44'],
  ['Ajman', 'cityArray.AJMAN', '31'],
  ['Umm Al Quwain', 'cityArray.UMM_AL_QUWAIN', '212'],
  ['Ras Al Khaimah', 'cityArray.RAS_AL_KHAIMAH', '69'],
  ['Fujairah', 'cityArray.FUJAIRAH', '78'],
  ['Al Ain', 'cityArray.AL_AIN', '18'],
];

List addRentFrequencyItems = [
  //'filter.lbl_price_type_any',
  'filter.lbl_price_type_yearly',
  'filter.lbl_price_type_monthly',
  'filter.lbl_price_type_weekly',
  'filter.lbl_price_type_daily',
];

List filterRentFrequencyItems = [
  'filter.lbl_price_type_any',
  'filter.lbl_price_type_daily',
  'filter.lbl_price_type_weekly',
  'filter.lbl_price_type_monthly',
  'filter.lbl_price_type_yearly',
];

List filterRoomItems = ["1", "2", "3", "4", "5", "6", "7", "8+"];

List dialCodes = ['050', '052', '054', '055', '056', '058'];

List filterYearItems =
    List.generate(40, (index) => (DateTime.now().year - index).toString());

List filterPropertyAreaItems =
    List.generate(35, (index) => (800 * (index + 1)));

List filterPriceItems =
    List.generate(115, (index) => (1000000 + (100000 * index)));

dynamic notifykey = '';
