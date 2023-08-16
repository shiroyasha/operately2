import { gql, useMutation } from "@apollo/client";

export interface KeyResource {
  id: string;
  title: string;
  link: string;
}

export const GQL_FRAGMENT = gql`
  {
    id
    title
    link
  }
`;

export const ADD_KEY_RESOURCE = gql`
  mutation AddKeyResource($input: AddKeyResourceInput!) {
    addKeyResource(input: $input) {
      id
      title
      link
    }
  }
`;

export function useAddKeyResourceMutation(options = {}) {
  return useMutation(ADD_KEY_RESOURCE, options);
}

export const EDIT_KEY_RESOURCE = gql`
  mutation EditKeyResource($input: EditKeyResourceInput!) {
    editKeyResource(input: $input) {
      id
    }
  }
`;

export function useEditKeyResourceMutation(options = {}) {
  return useMutation(EDIT_KEY_RESOURCE, options);
}

export const REMOVE_KEY_RESOURCE = gql`
  mutation RemoveKeyResource($id: ID!) {
    removeKeyResource(id: $id) {
      id
    }
  }
`;

export function useRemoveKeyResourceMutation(options = {}) {
  return useMutation(REMOVE_KEY_RESOURCE, options);
}