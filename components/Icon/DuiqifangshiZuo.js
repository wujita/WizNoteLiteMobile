/* eslint-disable */

import React from 'react';
import { Svg, Path } from 'react-native-svg';
import { getIconColor } from './helper';

let DuiqifangshiZuo = ({ size, color, ...rest }) => {
  return (
    <Svg viewBox="0 0 1024 1024" width={size} height={size} {...rest}>
      <Path
        d="M576 682.666667a21.333333 21.333333 0 0 1 21.333333 21.333333v42.666667a21.333333 21.333333 0 0 1-21.333333 21.333333h-384a21.333333 21.333333 0 0 1-21.333333-21.333333v-42.666667a21.333333 21.333333 0 0 1 21.333333-21.333333h384z m256-213.333334a21.333333 21.333333 0 0 1 21.333333 21.333334v42.666666a21.333333 21.333333 0 0 1-21.333333 21.333334h-640a21.333333 21.333333 0 0 1-21.333333-21.333334v-42.666666a21.333333 21.333333 0 0 1 21.333333-21.333334h640z m0-213.333333a21.333333 21.333333 0 0 1 21.333333 21.333333v42.666667a21.333333 21.333333 0 0 1-21.333333 21.333333h-640a21.333333 21.333333 0 0 1-21.333333-21.333333v-42.666667a21.333333 21.333333 0 0 1 21.333333-21.333333h640z"
        fill={getIconColor(color, 0, '#333333')}
      />
    </Svg>
  );
};

DuiqifangshiZuo.defaultProps = {
  size: 18,
};

DuiqifangshiZuo = React.memo ? React.memo(DuiqifangshiZuo) : DuiqifangshiZuo;

export default DuiqifangshiZuo;
