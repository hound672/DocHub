<script>
  import { isObjectEmpty, warn, convertVNodeArray } from '@front/helpers/misc';
  import { errorMiddleware } from '@front/helpers/http';
  import errConstants from '@front/constants/errConstants.json';
  
  import DefaultFallback from './DefaultFallback.vue';

  export default {
    name: 'ErrorBoundary',
    props: {
      fallBack: {
        type: Object,
        default: () => DefaultFallback
      },
      onError: {
        type: Function,
        default: null
      },
      params: {
        type: Object,
        // eslint-disable-next-line @typescript-eslint/no-empty-function
        default: () => {}
      },
      stopPropagation: {
        type: Boolean,
        default: false
      },
      tag: {
        type: String,
        default: 'div'
      }
    },
    data() {
      return {
        err: '',
        info: '',
        hasError: null
      };
    },
    errorCaptured(err, vm, info = '') {
      this.hasError = true;
      this.err = err;
      this.info = info;
      this.$emit('errorCaptured', { err, vm, info });

      if (this.onError) {
        this.onError(err, vm, info);
      }

      if (this.stopPropagation) {
        return false;
      }
    },
    render(createElement) {
      const content = this.$slots.default;
      const isScoped = this.$scopedSlots.boundary;
      let scopedSlot;

      if (isScoped) {
        scopedSlot = this.$scopedSlots.boundary({
          hasError: this.hasError,
          err: this.err,
          info: this.info
        });
      }

      const fallbackOrScoped = isScoped
        ? scopedSlot
        : createElement(this.fallBack, errorMiddleware(this.params));

      if (this.hasError || this.params.error) {
        return Array.isArray(fallbackOrScoped)
          ? convertVNodeArray(createElement, this.tag, fallbackOrScoped)
          : fallbackOrScoped;
      }

      if (isScoped) {
        if (!this.$scopedSlots.boundary()) {
          return warn(errConstants.CHILD_EL_IS_NULL);
        }

        return Array.isArray(scopedSlot)
          ? convertVNodeArray(createElement, this.tag, scopedSlot)
          : scopedSlot;
      }

      if (isObjectEmpty(this.$slots)) {
        return warn(errConstants.CHILD_EL_IS_NULL);
      }

      return Array.isArray(content)
        ? convertVNodeArray(createElement, this.tag, content)
        : content;
    }
  };
</script>
