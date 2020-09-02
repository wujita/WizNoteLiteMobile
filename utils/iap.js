import { Platform } from 'react-native';
import * as RNIap from 'react-native-iap';

// array of Product ID/sku
const productSkus = Platform.select({
  ios: [
    'cn.wiz.note.lite.year',
  ],
  android: [
    'cn.wiz.note.lite.year',
  ],
});

export async function getProducts() {
  try {
    const products = await RNIap.getProducts(productSkus);
    return products;
  } catch (err) {
    console.warn(err.code, err.message);
  }
  return null;
}

export async function restorePurchases() {
  try {
    const purchases = await RNIap.getAvailablePurchases();

    purchases.forEach((purchase) => {
      switch (purchase.productId) {
        case 'cn.wiz.note.lite.year':
          RNIap.finishTransaction(purchase);
          break;
        default:
          break;
      }
    });
  } catch (err) {
    console.warn(err); // standardized err.code and err.message available
  }
}

export async function requestPurchase(sku) {
  try {
    const ProductPurchase = await RNIap.requestPurchase(sku, false);
    return ProductPurchase;
  } catch (err) {
    console.warn(err.code, err.message);
  }
  return null;
}

export async function requestSubscription(sku) {
  try {
    const ProductPurchase = await RNIap.requestSubscription(sku);
    return ProductPurchase;
  } catch (err) {
    console.warn(err.code, err.message);
  }
  return null;
}
