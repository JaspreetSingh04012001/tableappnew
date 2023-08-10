import 'package:efood_table_booking/controller/cart_controller.dart';
import 'package:efood_table_booking/data/api/api_checker.dart';
import 'package:efood_table_booking/data/model/response/cart_model.dart';
import 'package:efood_table_booking/data/model/response/category_model.dart';
import 'package:efood_table_booking/data/model/response/product_model.dart';
import 'package:efood_table_booking/data/repository/product_repo.dart';
import 'package:efood_table_booking/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class ProductController extends GetxController implements GetxService {
  final ProductRepo productRepo;
  ProductController({required this.productRepo});

  bool _isLoading = false;
  final List<int> _variationIndex = [];
  int _quantity = 1;
  int _cartIndex = -1;
  List<bool> _addOnActiveList = [];
  List<int> _addOnQtyList = [];
  final List<String> _productTypeList = ['all', 'non_veg', 'veg'];
  String _selectedProductType = 'all';
  List<Product>? _productList;
  int _pageViewCurrentIndex = 0;
  List<CategoryModel>? _categoryList;
  String? _selectedCategory;
  bool _isSearch = true;
  int? _totalSize;
  List<int> _offsetList = [];
  List<Product>? _filterList;
  bool searchIs = false;
  List<List<bool>> _selectedVariations = [];

  int productOffset = 1;

  bool get isLoading => _isLoading;
  List<String> get productTypeList => _productTypeList;
  List<Product?>? get productList => _productList;
  int get quantity => _quantity;
  List<bool> get addOnActiveList => _addOnActiveList;
  List<int> get addOnQtyList => _addOnQtyList;
  int get cartIndex => _cartIndex;
  List<int>? get variationIndex => _variationIndex;
  int get pageViewCurrentIndex => _pageViewCurrentIndex;
  List<CategoryModel>? get categoryList => _categoryList;
  String? get selectedCategory => _selectedCategory;
  bool get isSearch => _isSearch;
  int? get totalSize => _totalSize;
  List<Product?>? get filterList => _filterList;
  String get selectedProductType => _selectedProductType;
  List<List<bool>> get selectedVariations => _selectedVariations;

  void isSearchChange(bool vale) {
    _isSearch = vale;
    update();
  }

  set filterListSet(List<Product>? value) {
    _filterList = value;
  }

  set setSelectedProductType(String type) {
    _selectedProductType = type;
  }

  Future<void> getProductList(bool reload, bool notify,
      {String? productType,
      String? searchPattern,
      String? categoryId,
      int offset = 1}) async {
    _isLoading = true;
    searchIs = false;

    if (reload || offset == 1) {
      _productList = null;
      _pageViewCurrentIndex = 0;
      _offsetList = [];
      productOffset = 1;
    }
    if (notify) {
      update();
    }
    if (_productList == null || reload || !_offsetList.contains(offset)) {
      _offsetList = [];
      _offsetList.add(offset);
      searchIs = searchPattern != null;
      Response response = await productRepo.getProductList(
          offset, productType, searchPattern, categoryId);
      if (response.statusCode == 200) {
        if (reload || offset == 1) {
          _productList = [];
        }
        _productList?.addAll(ProductModel.fromJson(response.body).products!);
        _totalSize = ProductModel.fromJson(response.body).totalSize;
      } else {
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }
  }

  void initData(Product product, CartModel? cart) {
    _selectedVariations = [];
    _addOnQtyList = [];
    _addOnActiveList = [];

    if (cart != null && cart.variations != null) {
      _quantity = cart.quantity!;
      _selectedVariations.addAll(cart.variations!);
      List<int> addOnIdList = [];
      cart.addOnIds?.forEach((addOnId) => addOnIdList.add(addOnId.id!));
      product.addOns?.forEach((addOn) {
        if (addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          if (cart.addOnIds != null) {
            _addOnQtyList
                .add(cart.addOnIds![addOnIdList.indexOf(addOn.id!)].quantity!);
          }
        } else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      });
    } else {
      _quantity = 1;
      if (product.variations != null) {
        product.variations?.forEach((element) {});

        for (int index = 0; index < product.variations!.length; index++) {
          _selectedVariations.add([]);
          if (product.variations![index].variationValues != null) {
            for (int i = 0;
                i < product.variations![index].variationValues!.length;
                i++) {
              _selectedVariations[index].add(false);
            }
          }
        }
      }

      product.addOns?.forEach((addOn) {
        _addOnActiveList.add(false);
        _addOnQtyList.add(1);
      });
    }
  }

  int setExistInCart(Product product, {bool notify = true}) {
    List<String> variationList = [];
    for (int index = 0; index < product.choiceOptions!.length; index++) {
      variationList.add(product
          .choiceOptions![index].options![_variationIndex[index]]
          .replaceAll(' ', ''));
    }
    String variationType = '';
    bool isFirst = true;
    for (var variation in variationList) {
      if (isFirst) {
        variationType = '$variationType$variation';
        isFirst = false;
      } else {
        variationType = '$variationType-$variation';
      }
    }
    _cartIndex = Get.find<CartController>().getCartIndex(product);
    if (_cartIndex != -1) {
      _quantity = Get.find<CartController>().cartList[_cartIndex].quantity!;
      _addOnActiveList = [];
      _addOnQtyList = [];
      List<int> addOnIdList = [];
      Get.find<CartController>()
          .cartList[_cartIndex]
          .addOnIds
          ?.forEach((addOnId) => addOnIdList.add(addOnId.id!));
      product.addOns?.forEach((addOn) {
        if (addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList.add(Get.find<CartController>()
              .cartList[_cartIndex]
              .addOnIds![addOnIdList.indexOf(addOn.id!)]
              .quantity!);
        } else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      });
    }
    return _cartIndex;
  }

  void setCartVariationIndex(
      int index, int i, Product product, bool isMultiSelect) {
    if (!isMultiSelect) {
      for (int j = 0; j < _selectedVariations[index].length; j++) {
        if (product.variations != null) {
          if (product.variations![index].isRequired!) {
            _selectedVariations[index][j] = j == i;
          } else {
            if (_selectedVariations[index][j]) {
              _selectedVariations[index][j] = false;
            } else {
              _selectedVariations[index][j] = j == i;
            }
          }
        }
      }
    } else {
      if (!_selectedVariations[index][i] &&
          selectedVariationLength(_selectedVariations, index) >=
              product.variations![index].max!) {
        showCustomSnackBar(
            '${'maximum_variation_for'.tr} ${product.variations?[index].name} ${'is'.tr} ${product.variations?[index].max}',
            isToast: true);
      } else {
        _selectedVariations[index][i] = !_selectedVariations[index][i];
      }
    }
    update();
  }

  int selectedVariationLength(List<List<bool>> selectedVariations, int index) {
    int length = 0;
    for (bool isSelected in selectedVariations[index]) {
      if (isSelected) {
        length++;
      }
    }
    return length;
  }

  void addAddOn(bool isAdd, int index) {
    _addOnActiveList[index] = isAdd;
    update();
  }

  void setAddOnQuantity(bool isIncrement, int index) {
    if (isIncrement) {
      _addOnQtyList[index] = _addOnQtyList[index] + 1;
    } else {
      _addOnQtyList[index] = _addOnQtyList[index] - 1;
    }
    update();
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity + 1;
    } else {
      _quantity = _quantity - 1;
    }
    update();
  }

  updatePageViewCurrentIndex(int index) {
    _pageViewCurrentIndex = index;
    update();
  }

  Future<void> getCategoryList(bool reload) async {
    if (_categoryList == null || reload) {
      Response response = await productRepo.getCategoryList();
      if (response.statusCode == 200) {
        _categoryList = [];
        response.body.forEach((category) {
          _categoryList?.add(CategoryModel.fromJson(category));
        });
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  setSelectedCategory(String? id) {
    _selectedCategory = id;
    update();
  }
}
